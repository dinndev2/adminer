import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["column"]

  connect() {
    console.log(Sortable)
    this.columnTargets.forEach((col) => {
      Sortable.create(col, {
        group: "kanban",        // allow cross-column moves
        animation: 150,
        sort: true,
        draggable: ".item",
        onEnd: (evt) => this.persist(evt),
      })
    })
  }

  persist(evt) {
    const cardId = evt.item.dataset.id
    const newColumn = evt.to.dataset.column // e.g. "booked", "in_progress"
    const newIndex = evt.newIndex
    console.log(cardId)
    fetch(`/bookings/${cardId}/move`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({ column: newColumn, position: newIndex })
    })
  }
}