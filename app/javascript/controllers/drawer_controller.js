import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.close = this.close.bind(this)
    document.addEventListener("turbo:before-visit", this.close)
    document.addEventListener("turbo:before-cache", this.close)
  }

  disconnect() {
    document.removeEventListener("turbo:before-visit", this.close)
    document.removeEventListener("turbo:before-cache", this.close)
  }

  open() {
    this.panelTarget.classList.remove("hidden")
  }

  close() {
    this.panelTarget.classList.add("hidden")
  }
}
