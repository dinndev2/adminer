import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable", "fileInput", 'preview', "spin", 'submit']

  connect() { 
    this.onStart = this.onStart.bind(this)
    this.onEnd = this.onEnd.bind(this)

    this.element.addEventListener('turbo:submit-start', this.onStart) 
    this.element.addEventListener('turbo:submit-end', this.onStart)
  }

  toggleVisibility(e) {
    e.preventDefault()
    this.toggleableTarget.classList.toggle('invisible-form')
  }

  showOnError(e) {
    if (e.detail?.success) return
    this.toggleableTarget.classList.remove('invisible-form')
  }

  triggerUpload() {
    this.fileInputTarget.click()
  }

  onStart() {
    if (this.spinTarget) this.spinTarget.classList.remove('hidden')
    if (this.hasSubmitTarget) this.submitTarget.disabled = true
  }

  onEnd() {
    if (this.spinTarget) this.spinTarget.classList.add('hidden')
    if (this.hasSubmitTarget) this.submitTarget.disabled = false
  }

  disconnect() {
    this.element.removeEventListener('turbo:submit-start', this.onStart)
    this.element.removeEventListener('turbi:submit-end', this.onEnd)
  }
  
  preview() {
    const image = this.fileInputTarget.files[0] 

    if (!image) return
    // Only preview images
    if (!image.type.startsWith('image/')) return

    const reader = new FileReader()
    reader.addEventListener("load", (e) => {
      this.previewTarget.src = e.target.result

    })
    reader.readAsDataURL(image)
  }
} 
