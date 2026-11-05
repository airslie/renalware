import { Controller } from "@hotwired/stimulus"
import { debounce } from "../helpers/timing"

/*  Adds auto-submit to a form using @hotwired turbo
    Submits the form associated with the input
    Debounces changes to prevent chatter when typing into a textfield.

    Example usage:
      form_for ..
        data: {
        turbo: true,
        turbo_frame: "drugs",
        turbo_advance: true,
        controller: "form"
        action: "input->form#submit"
      }

    - turbo_frame is id the turbo_frame_tag name to replace eg a paginated table
    - turbo_advance: true will add to history as they search
    - action: "input->form#submit" will need to change depending on input type eg
      select, radio, but will cause the form to submit
*/
export default class extends Controller {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 300)
  }

  submit(event) {
    event.target.form.requestSubmit()
  }
}
