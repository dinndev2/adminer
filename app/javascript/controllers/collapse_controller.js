import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon", "toggle"]

  connect() {
    this.syncAria()
  }

  toggle() {
    const expanded = this.isExpanded()
    if (expanded) {
      this.collapse()
    } else {
      this.expand()
      this.closeSiblings()
    }
    this.syncAria()
  }

  syncAria() {
    if (!this.hasToggleTarget || !this.hasContentTarget) return
    const expanded = this.isExpanded()
    this.toggleTarget.setAttribute("aria-expanded", expanded.toString())
  }

  isExpanded() {
    return this.contentTarget.classList.contains("max-h-64")
  }

  expand() {
    this.contentTarget.classList.remove("max-h-0", "opacity-0")
    this.contentTarget.classList.add("max-h-64", "opacity-100")
    if (this.hasIconTarget) this.iconTarget.classList.add("rotate-90")
  }

  collapse() {
    this.contentTarget.classList.remove("max-h-64", "opacity-100")
    this.contentTarget.classList.add("max-h-0", "opacity-0")
    if (this.hasIconTarget) this.iconTarget.classList.remove("rotate-90")
  }

  closeSiblings() {
    const parent = this.element.parentElement
    if (!parent) return
    parent.querySelectorAll('[data-controller~="collapse"]').forEach((el) => {
      if (el === this.element) return
      const content = el.querySelector('[data-collapse-target="content"]')
      const icon = el.querySelector('[data-collapse-target="icon"]')
      const toggle = el.querySelector('[data-collapse-target="toggle"]')
      if (content) {
        content.classList.remove("max-h-64", "opacity-100")
        content.classList.add("max-h-0", "opacity-0")
      }
      if (icon) icon.classList.remove("rotate-90")
      if (toggle) toggle.setAttribute("aria-expanded", "false")
    })
  }
}
