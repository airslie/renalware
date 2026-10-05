import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day"]

  deselectAll(event) {
    event.preventDefault()
    this.dayTargets.forEach((day) => {
      day.checked = false
    })
  }
}
