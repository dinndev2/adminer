import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["wrapper", "content"]

  connect() {
    document.addEventListener('turbo:frame-load', this.afterFrameLoad)
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd)
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this.afterFrameLoad)
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd)
  }

  afterFrameLoad = (event) => {
    if (event.target.id === "modal-content") {
      this.open()
    }
  }

  handleSubmitEnd = (event) => {
    if (event.detail.success) {
      this.close()
    }
  }

  open() {
    this.wrapperTarget.classList.add('show')
    this.wrapperTarget.classList.remove('hide')
    this.contentTarget.classList.add('pop')
    this.contentTarget.classList.remove('fade')
  }

  close() {
    this.wrapperTarget.classList.remove('show')
    this.wrapperTarget.classList.add('hide')
    this.contentTarget.classList.remove('pop')
    this.contentTarget.classList.add('fade')
  }
}
