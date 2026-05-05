import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "toggleable"]

  connect() {
    this.update()
  }

  update(event) {
    const deathSelected = this.selectedCode === "death"

    this.toggleableTargets.forEach((target) => {
      target.hidden = deathSelected
    })

    if (event && deathSelected) {
      alert(
        "Please note that after saving the Death modality, all current prescriptions will be terminated!"
      )
    }
  }

  get selectedCode() {
    const selectedOption = this.selectTarget.options[this.selectTarget.selectedIndex]
    return selectedOption?.dataset.code
  }
}
