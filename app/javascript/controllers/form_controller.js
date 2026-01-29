import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable", "fileInput", 'preview']

  toggleVisibility(e) {
    e.preventDefault()
    this.toggleableTarget.classList.toggle('invisible-form')
  }

  triggerUpload() {
    this.fileInputTarget.click()
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