import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  setAllToNo(event) {
    event.preventDefault()
    this.element
      .querySelectorAll('input[type="radio"][value="no"], input[type="radio"][value="non_smoker"]')
      .forEach((input) => {
        input.checked = true
      })
  }
}
