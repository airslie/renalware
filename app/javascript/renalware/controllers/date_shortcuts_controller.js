import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  today(event) {
    event.preventDefault()
    this.inputTarget._flatpickr.setDate(new Date(), true)
  }

  clear(event) {
    event.preventDefault()
    this.inputTarget._flatpickr.clear()
  }
}
