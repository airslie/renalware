// From https://www.stimulus-components.com/docs/stimulus-read-more/
// Thx
// See also the css class .line-clamp

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = {
    moreText: String,
    lessText: String
  }

  connect() {
    this.open = false
  }

  toggle(event) {
    this.open === false ? this.show(event) : this.hide(event)
  }

  show(event) {
    this.open = true

    const target = event.target
    target.innerHTML = this.lessTextValue
    this.contentTarget.style.setProperty("--read-more-line-clamp", "'unset'")
  }

  hide(event) {
    this.open = false

    const target = event.target
    target.innerHTML = this.moreTextValue
    this.contentTarget.style.removeProperty("--read-more-line-clamp")
  }
}
