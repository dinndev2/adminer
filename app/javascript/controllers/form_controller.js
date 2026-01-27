import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable"]

  toggleVisibility(e) {
    e.preventDefault()
    this.toggleableTarget.classList.toggle('invisible-form')
  }
} 