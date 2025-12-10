import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["menuItem", "submenu", "chevron"]

  connect() {
    console.log("Sidebar controller connected")
    this.initializeActiveStates()
  }

  toggleSubmenu(event) {
    event.preventDefault()
    const menuItem = event.currentTarget.closest('[data-sidebar-target="menuItem"]')
    const submenu = menuItem.querySelector('[data-sidebar-target="submenu"]')
    const chevron = menuItem.querySelector('[data-sidebar-target="chevron"]')

    if (submenu) {
      if (submenu.classList.contains('hidden')) {
        // Show submenu
        submenu.classList.remove('hidden')
        submenu.classList.add('animate-slide-down')
        chevron.style.transform = 'rotate(180deg)'
      } else {
        // Hide submenu
        submenu.classList.add('hidden')
        submenu.classList.remove('animate-slide-down')
        chevron.style.transform = 'rotate(0deg)'
      }
    }
  }

  initializeActiveStates() {
    // Set active state based on current URL
    const currentPath = window.location.pathname
    this.menuItemTargets.forEach(item => {
      const link = item.querySelector('a')
      if (link && link.getAttribute('href') === currentPath) {
        item.classList.add('menu-item-active')
        item.classList.remove('text-blue-200')

        // If this item has a parent submenu, open it
        const parentSubmenu = item.closest('[data-sidebar-target="submenu"]')
        if (parentSubmenu) {
          parentSubmenu.classList.remove('hidden')
          const parentChevron = parentSubmenu.previousElementSibling.querySelector('[data-sidebar-target="chevron"]')
          if (parentChevron) {
            parentChevron.style.transform = 'rotate(180deg)'
          }
        }
      }
    })
  }
}