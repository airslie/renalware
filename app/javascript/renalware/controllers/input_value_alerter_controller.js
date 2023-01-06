import { Controller } from "@hotwired/stimulus"

/*
  Adds a warning if selected value is not allowed
*/
export default class extends Controller {
  static values = {
    notRecommended: Array,
  }

  static targets = ["input", "message"]

  connect() {
    this.toggleMessage()
  }

  change() {
    this.toggleMessage()
  }

  toggleMessage() {
    if (this.notRecommendedValue.includes(this.inputTarget.value)) {
      this.messageTarget.classList.remove("hidden")
    } else {
      this.messageTarget.classList.add("hidden")
    }
  }
}
