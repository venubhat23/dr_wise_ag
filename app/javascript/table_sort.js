// Click-to-sort for every table with a <thead> in the admin.
//
// Every sortable header shows a faint ⇅ icon; click once for ascending, again
// for descending, and the active column gets a coloured ▲/▼ pill.
//
// Two modes:
//  * All records (server) - on paginated lists that go through
//    ConfigurablePagination#paginate_records, the layout emits
//    <meta name="server-sort-columns">. A header that maps to one of those DB
//    columns reloads the page with ?sort=<column>&direction=asc|desc, so the
//    whole list is sorted, and the sort survives page / per-page changes.
//    Mapping: `data-sort-key="column"` on the <th>, otherwise guessed from the
//    header text ("Created" -> created_at, "Status" -> status, "Name" -> name
//    / first_name ...).
//  * This page (client) - everything else sorts the rows already on the page.
//    Numbers (incl. "Rs. 1,234", "₹500", "12%"), dates ("02 Oct 2026",
//    "2026-10-02", "02/10/2026") and text are detected per column; blanks go last.
//
// Opt out: `data-no-sort` on the <table>, or `no-sort` class on a <th>.
// Columns titled Action(s) / Select / Options are never sortable.
// Override a cell's client sort key with `data-sort-value="..."` on the <td>.

const MONTHS = { jan: 0, feb: 1, mar: 2, apr: 3, may: 4, jun: 5, jul: 6, aug: 7, sep: 8, oct: 9, nov: 10, dec: 11 }
const INTERACTIVE = 'a, button, input, select, textarea, label, .dropdown, [data-bs-toggle]'
const NEVER_SORT = /^(actions?|select|options?|operations?|manage)$/i
const BLANKS = new Set(['', '-', '—', 'N/A', 'n/a'])

// Header text -> extra column candidates that the plain slug wouldn't find.
const SYNONYMS = {
  name: ['name', 'full_name', 'first_name', 'company_name'],
  created: ['created_at'], date: ['created_at'], joined: ['created_at'], registered: ['created_at'],
  added_on: ['created_at'], created_on: ['created_at'], created_date: ['created_at'],
  updated: ['updated_at'], last_updated: ['updated_at'],
  phone: ['mobile', 'phone'], mobile: ['mobile', 'phone'], contact: ['mobile', 'email', 'phone'],
  email: ['email'], kyc: ['kyc_status'], kyc_status: ['kyc_status'],
  premium: ['total_premium', 'net_premium', 'premium'], amount: ['amount', 'total_amount'],
  start_date: ['policy_start_date', 'start_date'], end_date: ['policy_end_date', 'end_date'],
  expiry: ['policy_end_date', 'expiry_date'], expiry_date: ['policy_end_date', 'expiry_date'],
  policy_no: ['policy_number'], policy: ['policy_number'], company: ['insurance_company_name', 'company_name'],
  insurer: ['insurance_company_name'], type: ['customer_type', 'type', 'policy_type'],
  city: ['city'], state: ['state'], pan: ['pan_no', 'pan_number'], code: ['referral_code', 'code'],
  referral_code: ['referral_code'], requested: ['created_at'], requested_on: ['created_at'],
  booking_date: ['policy_booking_date', 'booking_date'], client_name: ['first_name', 'name'], customer_name: ['first_name', 'name']
}

// ---------- client-side (this page) ----------

function parseDate(text) {
  let m = text.match(/^(\d{1,2})[\s-]([A-Za-z]{3})[a-z]*[\s-,]+(\d{4})(?:[\s,]+(\d{1,2}):(\d{2})\s*([AaPp][Mm])?)?/)
  if (m && MONTHS[m[2].toLowerCase()] !== undefined) {
    let hours = m[4] ? parseInt(m[4], 10) : 0
    if (m[6]) hours = (hours % 12) + (m[6].toLowerCase() === 'pm' ? 12 : 0)
    return new Date(+m[3], MONTHS[m[2].toLowerCase()], +m[1], hours, m[5] ? +m[5] : 0).getTime()
  }
  m = text.match(/^([A-Za-z]{3})[a-z]*\s+(\d{1,2}),?\s+(\d{4})/)
  if (m && MONTHS[m[1].toLowerCase()] !== undefined) return new Date(+m[3], MONTHS[m[1].toLowerCase()], +m[2]).getTime()
  m = text.match(/^(\d{4})-(\d{2})-(\d{2})/)
  if (m) return new Date(+m[1], +m[2] - 1, +m[3]).getTime()
  m = text.match(/^(\d{1,2})[/.](\d{1,2})[/.](\d{4})/) // Indian dd/mm/yyyy
  if (m) return new Date(+m[3], +m[2] - 1, +m[1]).getTime()
  return null
}

function parseNumber(text) {
  const cleaned = text.replace(/^(Rs\.?|INR|₹)\s*/i, '').replace(/[,%\s]/g, '').replace(/^₹/, '')
  return /^[-+]?\d+(\.\d+)?$/.test(cleaned) ? parseFloat(cleaned) : null
}

function cellText(row, index) {
  const cell = row.cells[index]
  if (!cell) return ''
  return (cell.dataset.sortValue ?? cell.innerText ?? '').trim()
}

// A tbody we can safely reorder: no rowspans. Full-width single-cell rows
// (expand/detail rows) travel with the row above them.
function rowGroups(tbody) {
  const groups = []
  for (const row of tbody.rows) {
    if ([...row.cells].some(c => c.rowSpan > 1)) return null
    const isDetail = row.cells.length === 1 && row.cells[0].colSpan > 1
    if (isDetail && groups.length) groups[groups.length - 1].push(row)
    else groups.push([row])
  }
  return groups
}

function columnIndex(th) {
  let index = 0
  for (const cell of th.parentElement.cells) {
    if (cell === th) break
    index += cell.colSpan || 1
  }
  return index
}

function markActive(th, direction) {
  for (const other of th.parentElement.cells) {
    delete other.dataset.sortDir
    other.removeAttribute('aria-sort')
  }
  th.dataset.sortDir = direction
  th.setAttribute('aria-sort', direction === 'asc' ? 'ascending' : 'descending')
}

function sortClientSide(table, th) {
  const index = columnIndex(th)
  const direction = th.dataset.sortDir === 'asc' ? 'desc' : 'asc'
  markActive(th, direction)

  for (const tbody of table.tBodies) {
    const groups = rowGroups(tbody)
    if (!groups || groups.length < 2) continue

    const texts = groups.map(g => cellText(g[0], index))
    const filled = texts.filter(t => !BLANKS.has(t))
    let parse = t => t.toLowerCase()
    if (filled.length && filled.every(t => parseNumber(t) !== null)) parse = parseNumber
    else if (filled.length && filled.every(t => parseDate(t) !== null)) parse = parseDate

    const keyed = groups.map((g, i) => {
      const blank = BLANKS.has(texts[i])
      return { g, i, blank, key: blank ? null : parse(texts[i]) }
    })
    const sign = direction === 'asc' ? 1 : -1
    keyed.sort((a, b) => {
      if (a.blank !== b.blank) return a.blank ? 1 : -1
      if (a.blank) return a.i - b.i
      const cmp = typeof a.key === 'number'
        ? a.key - b.key
        : String(a.key).localeCompare(String(b.key), undefined, { numeric: true })
      return cmp * sign || a.i - b.i
    })
    const frag = document.createDocumentFragment()
    keyed.forEach(k => k.g.forEach(row => frag.appendChild(row)))
    tbody.appendChild(frag)
  }
}

// ---------- server-side (all records) ----------

function serverColumns() {
  const meta = document.querySelector('meta[name="server-sort-columns"]')
  return meta ? new Set(meta.content.split(',').filter(Boolean)) : null
}

function headerLabel(th) {
  return th.innerText.replace(/[⇅▲▼↑↓]/g, '').trim()
}

// Only the list that owns the pagination bar is sorted server-side.
function isPaginatedTable(table) {
  let el = table
  for (let i = 0; i < 6 && el; i++) {
    el = el.parentElement
    if (el && el.querySelector('.pagination, .per-page-selector')) return true
  }
  return false
}

function serverKeyFor(th, columns) {
  if (!columns) return null
  const explicit = th.dataset.sortKey
  if (explicit) return columns.has(explicit) ? explicit : null

  const slug = headerLabel(th).toLowerCase().replace(/&/g, 'and').replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, '')
  if (!slug) return null
  const candidates = [...(SYNONYMS[slug] || []), slug, `${slug}_at`, `${slug}_date`, `${slug}_name`, `${slug}_status`, `${slug}_number`]
  return candidates.find(c => columns.has(c)) || null
}

function sortServerSide(th, key) {
  const url = new URL(window.location.href)
  const current = url.searchParams.get('sort') === key ? url.searchParams.get('direction') : null
  url.searchParams.set('sort', key)
  url.searchParams.set('direction', current === 'asc' ? 'desc' : 'asc')
  url.searchParams.set('page', '1')
  markActive(th, current === 'asc' ? 'desc' : 'asc')
  th.classList.add('sort-loading')
  if (window.Turbo) window.Turbo.visit(url.toString())
  else window.location.href = url.toString()
}

// ---------- wiring ----------

function sortableTable(th) {
  const table = th.closest('table')
  if (!table || table.hasAttribute('data-no-sort') || table.classList.contains('dataTable')) return null
  if (th.classList.contains('no-sort') || th.closest('thead') !== table.tHead) return null
  if (th.parentElement !== table.tHead.rows[table.tHead.rows.length - 1]) return null // multi-row headers: last row only
  const label = headerLabel(th)
  if (!label || NEVER_SORT.test(label) || th.querySelector('input, select, button')) return null
  if (![...table.tBodies].some(tb => tb.rows.length > 1)) return null // nothing to sort
  return table
}

// Decorate headers: ⇅ icon, tooltip, and the active server sort from the URL.
function decorate() {
  const columns = serverColumns()
  const params = new URLSearchParams(window.location.search)
  const activeKey = params.get('sort')
  const activeDir = params.get('direction') === 'desc' ? 'desc' : 'asc'

  document.querySelectorAll('table > thead > tr > th').forEach(th => {
    const table = sortableTable(th)
    th.classList.toggle('sortable-th', !!table)
    if (!table) return

    const key = isPaginatedTable(table) ? serverKeyFor(th, columns) : null
    th.dataset.sortMode = key ? 'server' : 'client'
    if (!th.title) th.title = key ? `Sort all records by ${headerLabel(th)}` : `Sort by ${headerLabel(th)}`
    if (key && key === activeKey && !th.dataset.sortDir) markActive(th, activeDir)
  })
}

document.addEventListener('click', (event) => {
  const th = event.target.closest('thead th')
  if (!th || event.target.closest(INTERACTIVE)) return
  const table = sortableTable(th)
  if (!table) return

  const key = isPaginatedTable(table) ? serverKeyFor(th, serverColumns()) : null
  if (key) sortServerSide(th, key)
  else sortClientSide(table, th)
})

document.addEventListener('turbo:load', decorate)
document.addEventListener('DOMContentLoaded', decorate)
if (document.readyState !== 'loading') decorate()

const style = document.createElement('style')
style.textContent = `
  th.sortable-th { cursor: pointer; user-select: none; white-space: nowrap; transition: background-color .15s ease, color .15s ease; }
  th.sortable-th::after {
    content: '⇅'; display: inline-flex; align-items: center; justify-content: center;
    margin-left: .4rem; min-width: 1.15rem; height: 1.15rem; padding: 0 .2rem;
    font-size: .72em; line-height: 1; border-radius: 999px; opacity: .35;
    vertical-align: middle; transition: opacity .15s ease, background-color .15s ease, color .15s ease;
  }
  th.sortable-th:hover { background-color: rgba(79, 70, 229, .06) !important; color: #4338ca; }
  th.sortable-th:hover::after { opacity: .8; }
  th.sortable-th[data-sort-dir] { background-color: rgba(79, 70, 229, .09) !important; color: #4338ca; }
  th.sortable-th[data-sort-dir]::after { content: '▲'; opacity: 1; background: #4f46e5; color: #fff; }
  th.sortable-th[data-sort-dir="desc"]::after { content: '▼'; }
  th.sortable-th.sort-loading::after { animation: table-sort-pulse .8s ease-in-out infinite; }
  @keyframes table-sort-pulse { 50% { opacity: .4; } }
`
document.head.appendChild(style)
