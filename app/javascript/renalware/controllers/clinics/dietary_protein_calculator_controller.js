import { Controller } from "@hotwired/stimulus"

/*  Single use controller only for the Dietetic Clinic Visit */

export default class extends Controller {
  static targets = ["proteinIntake", "output"]

  initialize() {
    this.calculate = this.calculate.bind(this)
  }

  connect() {
    // As weight is outside the scope of the controller
    // -> grab directly
    this.idealBodyWeightElement = document.querySelector(
      "#clinic_visit_document_ideal_body_weight"
    )

    this.idealBodyWeightElement.addEventListener("input", this.calculate)

    this.calculate()
  }
  disconnect() {
    this.idealBodyWeightElement.removeEventListener("input", this.calculate)
  }

  calculate() {
    const weight = this.idealBodyWeightElement.value
    const proteinIntake = this.proteinIntakeTarget.value
    const value =
      weight && proteinIntake
        ? Math.round((proteinIntake / weight) * 10) / 10 + " g/day/kg"
        : ""

    this.outputTarget.innerText = value
  }
}
