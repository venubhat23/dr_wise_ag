// Filters the sidebar menu as you type in #sidebar-search-input.
//
// Matches on menu labels and section titles (case-insensitive). A matching
// parent shows all of its submenu items; a matching submenu item shows its
// parent. Sections with nothing visible are hidden. Escape clears the search.

function label(el) {
  return (el?.innerText || '').trim().toLowerCase()
}

function setHidden(el, hidden) {
  if (hidden) el.setAttribute('data-search-hidden', '')
  else el.removeAttribute('data-search-hidden')
}

function filterSidebar(input) {
  const sidebar = input.closest('.modern-sidebar')
  if (!sidebar) return
  const query = input.value.trim().toLowerCase()
  sidebar.classList.toggle('searching', query !== '')

  let anyVisible = false
  sidebar.querySelectorAll('.sidebar-nav .nav-section').forEach(section => {
    const sectionMatch = !query || label(section.querySelector('.nav-section-title')).includes(query)
    let sectionVisible = false

    section.querySelectorAll(':scope > .nav-menu > .nav-item').forEach(item => {
      const parentLabel = label(item.querySelector(':scope > .nav-link-modern .nav-text'))
      const parentMatch = sectionMatch || parentLabel.includes(query)
      let childVisible = false

      item.querySelectorAll('.submenu-list > .nav-item').forEach(child => {
        const show = parentMatch || label(child.querySelector('.nav-text')).includes(query)
        setHidden(child, !show)
        if (show) childVisible = true
      })

      const show = parentMatch || childVisible
      setHidden(item, !show)
      if (show) sectionVisible = true
    })

    setHidden(section, !sectionVisible)
    if (sectionVisible) anyVisible = true
  })

  const empty = sidebar.querySelector('.sidebar-search-empty')
  if (empty) empty.hidden = anyVisible
}

document.addEventListener('input', (event) => {
  if (event.target.id === 'sidebar-search-input') filterSidebar(event.target)
})

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape' && event.target.id === 'sidebar-search-input') {
    event.target.value = ''
    filterSidebar(event.target)
  }
})
