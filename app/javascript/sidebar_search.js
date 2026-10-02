// Spotlight-style sidebar search for #sidebar-search-input.
//
// While a query is typed the regular menu is hidden and every sidebar link is
// ranked against it, best match first: exact > prefix > word prefix > substring
// > fuzzy (letters in order). A link also inherits a (weaker) score from its
// parent menu and section title, so "wa" lists all the Wallets pages on top.
//
// Keys: Ctrl/Cmd+K or "/" focuses the search, ↑/↓ move, Enter opens, Esc clears.

const MAX_RESULTS = 12

function text(el) {
  return (el?.innerText || el?.textContent || '').replace(/\s+/g, ' ').trim()
}

function escapeHtml(str) {
  return str.replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]))
}

// Returns { score, ranges } where ranges are [start, end) spans to highlight.
function match(label, query) {
  const l = label.toLowerCase()
  if (!query || !l) return { score: 0, ranges: [] }
  if (l === query) return { score: 100, ranges: [[0, l.length]] }
  if (l.startsWith(query)) return { score: 90, ranges: [[0, query.length]] }

  const wordStart = l.search(new RegExp(`\\b${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}`))
  if (wordStart > 0) return { score: 75, ranges: [[wordStart, wordStart + query.length]] }

  const idx = l.indexOf(query)
  if (idx >= 0) return { score: 55, ranges: [[idx, idx + query.length]] }

  // Fuzzy: all query letters appear in order (spaces ignored)
  const q = query.replace(/\s+/g, '')
  const ranges = []
  let pos = 0
  for (const ch of q) {
    const found = l.indexOf(ch, pos)
    if (found < 0) return { score: 0, ranges: [] }
    const last = ranges[ranges.length - 1]
    if (last && last[1] === found) last[1] = found + 1
    else ranges.push([found, found + 1])
    pos = found + 1
  }
  // Fewer, tighter chunks score higher
  return { score: Math.max(10, 35 - ranges.length * 4), ranges }
}

function highlight(label, ranges) {
  let html = ''
  let pos = 0
  ranges.forEach(([s, e]) => {
    html += escapeHtml(label.slice(pos, s)) + `<mark>${escapeHtml(label.slice(s, e))}</mark>`
    pos = e
  })
  return html + escapeHtml(label.slice(pos))
}

// Every navigable link in the sidebar with its breadcrumb context.
function collectEntries(sidebar) {
  const entries = []
  sidebar.querySelectorAll('.sidebar-nav .nav-section').forEach(section => {
    const sectionLabel = text(section.querySelector('.nav-section-title'))

    section.querySelectorAll(':scope > .nav-menu > .nav-item').forEach(item => {
      const head = item.querySelector(':scope > .nav-link-modern')
      const parentLabel = text(head?.querySelector('.nav-text'))
      const parentIcon = head?.querySelector('.icon-bg')

      if (head?.tagName === 'A') {
        entries.push({ link: head, label: parentLabel, crumbs: [sectionLabel], parentLabel: '', sectionLabel, icon: parentIcon })
      }

      item.querySelectorAll('.submenu-list a.nav-link-modern').forEach(link => {
        entries.push({
          link,
          label: text(link.querySelector('.nav-text')),
          crumbs: [sectionLabel, parentLabel].filter((c, i, a) => c && a.indexOf(c) === i),
          parentLabel,
          sectionLabel,
          icon: parentIcon,
          childIcon: link.querySelector(':scope > i.bi')
        })
      })
    })
  })
  return entries
}

function rank(entries, query) {
  return entries
    .map(entry => {
      const own = match(entry.label, query)
      const parent = match(entry.parentLabel, query).score * 0.8
      const section = match(entry.sectionLabel, query).score * 0.6
      return { ...entry, ranges: own.ranges, score: Math.max(own.score, parent, section) }
    })
    .filter(r => r.score > 0)
    .sort((a, b) => b.score - a.score || a.label.length - b.label.length)
    .slice(0, MAX_RESULTS)
}

function iconHtml(entry) {
  const bg = entry.icon ? [...entry.icon.classList].find(c => c.startsWith('gradient-')) || '' : ''
  const icon = entry.childIcon || entry.icon?.querySelector('i')
  const iconClass = icon ? [...icon.classList].filter(c => c === 'bi' || c.startsWith('bi-')).join(' ') : 'bi bi-arrow-right'
  return `<span class="ss-icon ${bg}"><i class="${iconClass}"></i></span>`
}

function render(sidebar, query) {
  const panel = sidebar.querySelector('.sidebar-search-results')
  const count = sidebar.querySelector('.sidebar-search-count')
  if (!panel) return

  sidebar.classList.toggle('searching', query !== '')
  if (!query) {
    panel.innerHTML = ''
    if (count) count.textContent = ''
    return
  }

  const results = rank(collectEntries(sidebar), query)
  sidebar._searchResults = results
  if (count) count.textContent = results.length ? `${results.length}` : ''

  if (!results.length) {
    panel.innerHTML = `
      <div class="ss-empty">
        <div class="ss-empty-icon"><i class="bi bi-search"></i></div>
        <div class="ss-empty-title">No matches for “${escapeHtml(query)}”</div>
        <div class="ss-empty-sub">Try a shorter or different word</div>
      </div>`
    return
  }

  panel.innerHTML = results.map((r, i) => {
    const badge = r.link.querySelector('.badge')
    return `
      ${i === 0 ? '<div class="ss-heading">Top match</div>' : ''}
      ${i === 1 ? '<div class="ss-heading">Other results</div>' : ''}
      <a href="${escapeHtml(r.link.getAttribute('href') || '#')}"
         class="ss-item ${i === 0 ? 'ss-top is-selected' : ''} ${r.link.classList.contains('active') ? 'is-current' : ''}"
         data-index="${i}" style="animation-delay:${Math.min(i, 8) * 25}ms">
        ${iconHtml(r)}
        <span class="ss-body">
          <span class="ss-label">${highlight(r.label, r.ranges)}</span>
          <span class="ss-crumbs">${r.crumbs.map(escapeHtml).join('<i class="bi bi-chevron-right"></i>')}</span>
        </span>
        ${badge ? `<span class="ss-badge">${escapeHtml(text(badge))}</span>` : ''}
        <i class="bi bi-arrow-return-left ss-enter"></i>
      </a>`
  }).join('')
}

function select(sidebar, index) {
  const items = sidebar.querySelectorAll('.ss-item')
  if (!items.length) return
  const next = (index + items.length) % items.length
  items.forEach((el, i) => el.classList.toggle('is-selected', i === next))
  items[next].scrollIntoView({ block: 'nearest' })
}

function selectedIndex(sidebar) {
  const el = sidebar.querySelector('.ss-item.is-selected')
  return el ? Number(el.dataset.index) : -1
}

function open(sidebar, index) {
  const result = sidebar._searchResults?.[index]
  if (result) result.link.click() // keeps Turbo navigation and any link data attributes
}

function clear(input) {
  input.value = ''
  render(input.closest('.modern-sidebar'), '')
}

document.addEventListener('input', (event) => {
  if (event.target.id !== 'sidebar-search-input') return
  const sidebar = event.target.closest('.modern-sidebar')
  if (sidebar) render(sidebar, event.target.value.trim().toLowerCase())
})

document.addEventListener('keydown', (event) => {
  const input = document.getElementById('sidebar-search-input')
  if (!input) return

  if (event.target === input) {
    const sidebar = input.closest('.modern-sidebar')
    if (event.key === 'Escape') { clear(input); input.blur() }
    else if (event.key === 'ArrowDown') { event.preventDefault(); select(sidebar, selectedIndex(sidebar) + 1) }
    else if (event.key === 'ArrowUp') { event.preventDefault(); select(sidebar, selectedIndex(sidebar) - 1) }
    else if (event.key === 'Enter') { event.preventDefault(); open(sidebar, Math.max(0, selectedIndex(sidebar))) }
    return
  }

  const typing = event.target.closest?.('input, textarea, select, [contenteditable="true"]')
  const shortcut = (event.key === 'k' && (event.ctrlKey || event.metaKey)) || (event.key === '/' && !typing)
  if (shortcut) {
    event.preventDefault()
    const sidebar = input.closest('.modern-sidebar')
    if (sidebar?.classList.contains('collapsed')) document.getElementById('desktopSidebarToggle')?.click()
    input.focus()
    input.select()
  }
})

document.addEventListener('click', (event) => {
  const item = event.target.closest('.ss-item')
  if (item) {
    event.preventDefault()
    open(item.closest('.modern-sidebar'), Number(item.dataset.index))
    return
  }
  if (event.target.closest('.sidebar-search-clear')) {
    const input = document.getElementById('sidebar-search-input')
    if (input) { clear(input); input.focus() }
  }
})

document.addEventListener('mousemove', (event) => {
  const item = event.target.closest?.('.ss-item')
  if (item && !item.classList.contains('is-selected')) select(item.closest('.modern-sidebar'), Number(item.dataset.index))
})

// Don't carry a stale query across Turbo page loads
document.addEventListener('turbo:load', () => {
  const input = document.getElementById('sidebar-search-input')
  if (input?.value) clear(input)
})
