// Spotlight-style sidebar search for #sidebar-search-input.
//
// While a query is typed the regular menu is hidden and every sidebar menu is
// ranked against it: exact > prefix > word prefix > substring > fuzzy (letters
// in order). A menu also scores through its pages and section title.
//
// Results are grouped by top-level menu ("Commissions", "Wallets", ...) with
// its pages listed underneath, best-matching menu first.
//
// Keys: ↑/↓ move, Enter opens the selected page, Esc clears.

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

// One group per top-level menu item, with its submenu links as children.
function collectGroups(sidebar) {
  const groups = []
  sidebar.querySelectorAll('.sidebar-nav .nav-section').forEach(section => {
    const sectionLabel = text(section.querySelector('.nav-section-title'))

    section.querySelectorAll(':scope > .nav-menu > .nav-item').forEach(item => {
      const head = item.querySelector(':scope > .nav-link-modern')
      if (!head) return
      const iconBg = head.querySelector('.icon-bg')
      groups.push({
        label: text(head.querySelector('.nav-text')),
        link: head.tagName === 'A' ? head : null,
        sectionLabel,
        gradient: iconBg ? [...iconBg.classList].find(c => c.startsWith('gradient-')) || '' : '',
        icon: iconClass(iconBg?.querySelector('i')),
        children: [...item.querySelectorAll('.submenu-list a.nav-link-modern')].map(link => ({
          label: text(link.querySelector('.nav-text')),
          link,
          icon: iconClass(link.querySelector(':scope > i.bi'))
        }))
      })
    })
  })
  return groups
}

function iconClass(i) {
  return i ? [...i.classList].filter(c => c === 'bi' || c.startsWith('bi-')).join(' ') : 'bi bi-dot'
}

// Groups ordered best match first. A matching menu shows all its pages;
// otherwise only the pages that match are listed under it.
function rank(groups, query) {
  return groups
    .map(group => {
      const own = match(group.label, query)
      const section = match(group.sectionLabel, query).score * 0.5
      const children = group.children
        .map(child => ({ ...child, ...match(child.label, query) }))
      const bestChild = Math.max(0, ...children.map(c => c.score)) * 0.9
      return {
        ...group,
        ranges: own.ranges,
        score: Math.max(own.score, bestChild, section),
        children: own.score > 0 || section >= bestChild ? children : children.filter(c => c.score > 0).sort((a, b) => b.score - a.score)
      }
    })
    .filter(g => g.score > 0 && (g.link || g.children.length))
    .sort((a, b) => b.score - a.score || words(a.label) - words(b.label) || a.label.localeCompare(b.label))
    .slice(0, MAX_RESULTS)
}

const words = label => label.split(' ').length

function badgeHtml(link) {
  const badge = link?.querySelector('.badge')
  return badge ? `<span class="ss-badge">${escapeHtml(text(badge))}</span>` : ''
}

function render(sidebar, query) {
  const panel = sidebar.querySelector('.sidebar-search-results')
  const count = sidebar.querySelector('.sidebar-search-count')
  if (!panel) return

  sidebar.classList.toggle('searching', query !== '')
  if (!query) {
    panel.innerHTML = ''
    sidebar._searchTargets = []
    if (count) count.textContent = ''
    return
  }

  const groups = rank(collectGroups(sidebar), query)
  const targets = [] // link to open for each selectable row, in display order
  if (count) count.textContent = groups.length ? `${groups.length}` : ''

  if (!groups.length) {
    sidebar._searchTargets = targets
    panel.innerHTML = `
      <div class="ss-empty">
        <div class="ss-empty-icon"><i class="bi bi-search"></i></div>
        <div class="ss-empty-title">No matches for “${escapeHtml(query)}”</div>
        <div class="ss-empty-sub">Try a shorter or different word</div>
      </div>`
    return
  }

  const row = (link, cls, inner) => {
    const i = targets.push(link) - 1
    const current = link?.classList.contains('active') ? 'is-current' : ''
    return `<a href="${escapeHtml(link?.getAttribute('href') || '#')}" class="ss-item ${cls} ${current}" data-index="${i}">${inner}</a>`
  }

  panel.innerHTML = groups.map((g, gi) => {
    const head = row(g.link || g.children[0]?.link, `ss-head ${gi === 0 ? 'ss-top' : ''}`, `
      <span class="ss-icon ${g.gradient}"><i class="${g.icon}"></i></span>
      <span class="ss-body">
        <span class="ss-label">${g.ranges.length ? highlight(g.label, g.ranges) : escapeHtml(g.label)}</span>
        <span class="ss-crumbs">${escapeHtml(g.sectionLabel)}${g.children.length ? ` · ${g.children.length} page${g.children.length > 1 ? 's' : ''}` : ''}</span>
      </span>
      ${badgeHtml(g.link)}
      <i class="bi ${g.link ? 'bi-arrow-return-left' : 'bi-chevron-down'} ss-enter"></i>`)

    const children = g.children.map(c => row(c.link, 'ss-child', `
      <i class="${c.icon} ss-child-icon"></i>
      <span class="ss-label">${c.ranges?.length ? highlight(c.label, c.ranges) : escapeHtml(c.label)}</span>
      ${badgeHtml(c.link)}
      <i class="bi bi-arrow-return-left ss-enter"></i>`)).join('')

    return `<div class="ss-group" style="animation-delay:${Math.min(gi, 8) * 30}ms">
      ${head}${children ? `<div class="ss-children">${children}</div>` : ''}
    </div>`
  }).join('')

  sidebar._searchTargets = targets
  panel.querySelector('.ss-item')?.classList.add('is-selected')
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
  // Clicking the real sidebar link keeps Turbo navigation and its data attributes
  sidebar._searchTargets?.[index]?.click()
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
  const input = event.target
  if (input.id !== 'sidebar-search-input') return

  const sidebar = input.closest('.modern-sidebar')
  if (event.key === 'Escape') { clear(input); input.blur() }
  else if (event.key === 'ArrowDown') { event.preventDefault(); select(sidebar, selectedIndex(sidebar) + 1) }
  else if (event.key === 'ArrowUp') { event.preventDefault(); select(sidebar, selectedIndex(sidebar) - 1) }
  else if (event.key === 'Enter') { event.preventDefault(); open(sidebar, Math.max(0, selectedIndex(sidebar))) }
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
