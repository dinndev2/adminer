import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 3000 },
  }

  connect() {
    this.timeoutId = setTimeout(() => this.hide(), this.timeoutValue)
  }

  disconnect() {
    if (this.timeoutId) clearTimeout(this.timeoutId)
  }

  hide() {
    this.element.classList.add("opacity-0", "pointer-events-none")
    setTimeout(() => this.element.classList.add("hidden"), 300)
  }
}
