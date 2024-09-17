import { Controller } from "@hotwired/stimulus"

// Set all select inputs options within the controller's element to selected if their
// value = matchValue (eg "no" in the case of tristate Yes No Unknown dropdown.)
// Example usage:
// div(data-controller="select-reset" data-select-reset-match-value="no")
//   <select>
//     <option value="no">No</option
//     <option value="yes">Yes</option
//     <option value="unknown">Unknown</option
//   ...

export default class extends Controller {
  static values = { match: String }

  reset_all(event) {
    const that = this
    const selectInputs = Array.prototype.slice.call(
      this.element.querySelectorAll("select")
    )
    selectInputs.forEach(function(a){
      a.value = that.matchValue
    })
  }
}
