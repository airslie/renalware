import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "destination"]

  copy(event) {
    event.preventDefault()
    const addressFields = this.sourceTarget.cloneNode(true)
    this.destinationTarget.replaceChildren(...addressFields.childNodes)
  }
}
