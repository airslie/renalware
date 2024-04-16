import { Controller } from "@hotwired/stimulus"

// Used in the HD Slot Request form (dialog) :
// - disable the MFFD checkbox unless the Inpatient checkbox is checked
// - uncheck MFFD when a user unchecks Inpatient
// - Add a logical 'disabled' class the the MFFD checkbox when disabling it, as a visual hint
export default class extends Controller {
  static targets = ["inpatient", "mffdCheckbox", "mffdLabel"] // medically fit for discharge checkbox
  static classes = [ "disabled" ] // css class for the MFFD label with disabled="disabled"

  connect() {
    this.inpatient_checked()
  }

  inpatient_checked() {
    if (this.inpatientTarget.checked === false) {
      this.mffdCheckboxTarget.checked = false
      this.mffdCheckboxTarget.disabled = "disabled"
      this.mffdLabelTarget.classList.add(this.disabledClass)
    } else {
      this.mffdCheckboxTarget.removeAttribute("disabled")
      this.mffdLabelTarget.classList.remove(this.disabledClass)
    }
  }
}
