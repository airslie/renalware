import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "trix" ]

  initInsertEventNotesIntoTrixEditor(event) {
    event.preventDefault()
    let notes = event.currentTarget.dataset.notes

    if (notes && this.trix) {
      this.trix.insertHTML(notes)
    } else {
      alert("There are no notes to insert")
    }
  }

  get trix() {
    return this.trixTarget.editor
  }
}
