import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.sync = this.sync.bind(this)
    document.addEventListener("turbo:load", this.sync)
    this.sync()
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.sync)
  }

  sync() {
    const currentPath = window.location.pathname

    this.element.querySelectorAll("[data-nav-item]").forEach((item) => {
      const active = this.isActive(item, currentPath)

      item.dataset.navActive = active.toString()
      item.setAttribute("class", active ? item.dataset.navActiveClass : item.dataset.navInactiveClass)

      if (active) {
        item.setAttribute("aria-current", "page")
      } else {
        item.removeAttribute("aria-current")
      }

      const icon = item.querySelector("[data-nav-icon]")
      if (icon) {
        icon.setAttribute("class", active ? icon.dataset.navActiveClass : icon.dataset.navInactiveClass)
      }
    })

    this.element.querySelectorAll("[data-nav-group]").forEach((group) => {
      const expanded = group.querySelector('[data-nav-item][data-nav-active="true"]') !== null
      const content = group.querySelector('[data-collapse-target="content"]')
      const toggle = group.querySelector('[data-collapse-target="toggle"]')
      const icon = group.querySelector('[data-collapse-target="icon"]')

      if (!content || !toggle || !icon) return

      content.classList.toggle("max-h-64", expanded)
      content.classList.toggle("opacity-100", expanded)
      content.classList.toggle("max-h-0", !expanded)
      content.classList.toggle("opacity-0", !expanded)
      toggle.setAttribute("aria-expanded", expanded.toString())
      icon.classList.toggle("rotate-90", expanded)
    })
  }

  isActive(item, currentPath) {
    const exact = item.dataset.navExact === "true"
    const path = item.dataset.navPath
    const startsWith = item.dataset.navStartsWith || path

    if (exact) return currentPath === path
    if (path === "/") return currentPath === "/"

    return currentPath.startsWith(startsWith)
  }
}
