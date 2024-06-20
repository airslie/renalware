//
// Src: https://github.com/excid3/stimulus-slimselect
//

import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  static values = {
    options: Object
  }

  // See also e.g. https://slimselectjs.com/settings
  // maxValuesShown: 100
  // placeholderText: this.placeholder
  connect() {
    this.slimselect = new SlimSelect({
      select: this.element,
      settings: {
        searchHighlight: true,
        allowDeselect: false
      },
      ...this.optionsValue,
    })
  }

  disconnect() {
    this.slimselect.destroy()
  }
}
