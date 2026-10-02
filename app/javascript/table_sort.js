// Click-to-sort for every table with a <thead> in the admin.
//
// Click a header to sort ascending, again for descending. Numbers (incl. "Rs. 1,234",
// "₹500", "12%"), dates ("02 Oct 2026", "2026-10-02", "02/10/2026") and text are
// detected per column; blank cells always go last. Only the rows currently on
// the page are sorted (server-paginated lists sort the visible page).
//
// Opt out: add `data-no-sort` to the <table> or `no-sort` class to a <th>.
// Override a cell's sort key with `data-sort-value="..."` on the <td>.

const MONTHS = { jan: 0, feb: 1, mar: 2, apr: 3, may: 4, jun: 5, jul: 6, aug: 7, sep: 8, oct: 9, nov: 10, dec: 11 }
const INTERACTIVE = 'a, button, input, select, textarea, label, .dropdown, [data-bs-toggle]'

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

function sortTable(table, th) {
  const headerRow = th.parentElement
  let index = 0
  for (const cell of headerRow.cells) {
    if (cell === th) break
    index += cell.colSpan || 1
  }

  const direction = th.dataset.sortDir === 'asc' ? 'desc' : 'asc'
  for (const other of headerRow.cells) delete other.dataset.sortDir
  th.dataset.sortDir = direction
  th.setAttribute('aria-sort', direction === 'asc' ? 'ascending' : 'descending')

  for (const tbody of table.tBodies) {
    const groups = rowGroups(tbody)
    if (!groups || groups.length < 2) continue

    const texts = groups.map(g => cellText(g[0], index))
    const filled = texts.filter(t => t !== '' && t !== '-' && t !== '—' && t !== 'N/A')
    let parse = t => t.toLowerCase()
    if (filled.length && filled.every(t => parseNumber(t) !== null)) parse = parseNumber
    else if (filled.length && filled.every(t => parseDate(t) !== null)) parse = parseDate

    const keyed = groups.map((g, i) => {
      const t = texts[i]
      const blank = t === '' || t === '-' || t === '—' || t === 'N/A'
      return { g, i, blank, key: blank ? null : parse(t) }
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

function sortableHeader(th) {
  const table = th.closest('table')
  if (!table || table.hasAttribute('data-no-sort') || table.classList.contains('dataTable')) return null
  if (th.classList.contains('no-sort') || th.closest('thead') !== table.tHead) return null
  if (th.parentElement !== table.tHead.rows[table.tHead.rows.length - 1]) return null // multi-row headers: last row only
  if (!th.innerText.trim() || th.querySelector('input, select, button')) return null
  return table
}

document.addEventListener('click', (event) => {
  const th = event.target.closest('thead th')
  if (!th || event.target.closest(INTERACTIVE)) return
  const table = sortableHeader(th)
  if (table) sortTable(table, th)
})

const style = document.createElement('style')
style.textContent = `
  table:not([data-no-sort]):not(.dataTable) > thead > tr:last-child > th:not(.no-sort) { cursor: pointer; user-select: none; }
  table:not([data-no-sort]):not(.dataTable) > thead > tr:last-child > th:not(.no-sort):hover { background-color: rgba(0,0,0,.04); }
  th[data-sort-dir]::after { content: ' ▲'; font-size: .7em; opacity: .7; }
  th[data-sort-dir="desc"]::after { content: ' ▼'; }
`
document.head.appendChild(style)
