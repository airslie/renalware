import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["displayable"] // element we are going to show/hide
  // attributeToTest: Name of the boolean data attribute on the selected option that determines if
  //                  the displayable target should be visible or not
  static values = {
    attributeToTest: String
  }

  /*
  For a SELECT, find the chosen option, and the data attribute we need (a boolean eg "true" whose
  name is in the attributeToTest value).  Hide or show the target element according to the boolean
  'test' attribute.
  */
  showhide(event) {
    event.preventDefault()
    if (event.target.tagName.toUpperCase() == "SELECT") {
      let selectedOption = event.target.options[event.target.selectedIndex]
      let display = selectedOption.dataset[this.attributeToTestValue] == "true" ? "block" : "none"
      this.displayableTarget.style.display = display
    }
  }
}
