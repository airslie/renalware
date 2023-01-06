// Add a data-frame-url property to every option of a dropdown.
// On option change, the `data-frame-url` will be assigned to
// a targetted turbo frame - set via `frameId` value

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    frameId: String,
  }

  change() {
    const url = this.element.selectedOptions[0].dataset.frameUrl
    const frame = document.getElementById(this.frameIdValue)
    frame.src = url
  }
}
