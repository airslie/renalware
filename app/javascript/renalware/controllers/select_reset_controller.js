import { Controller } from "@hotwired/stimulus"

// Set targeted selects to matchValue (eg "no" for Yes/No/Unknown dropdowns).
// Example usage:
// div(data-controller="select-reset" data-select-reset-match-value="no")
//   <select data-select-reset-target="select">
//     <option value="no">No</option
//     <option value="yes">Yes</option
//     <option value="unknown">Unknown</option
//   ...

export default class extends Controller {
  static targets = ["select"]
  static values = { match: String }

  reset_all(event) {
    event.preventDefault()
    this.selectTargets.forEach((select) => {
      select.value = this.matchValue
    })
  }
}
