import { Controller } from "@hotwired/stimulus"

/*  Single use controller only for the Dietetic Clinic Visit */

export default class extends Controller {
  static targets = ["previousWeight", "output"]

  static values = {
    weightSelector: String,
  }

  initialize() {
    this.calculate = this.calculate.bind(this)
  }

  connect() {
    // As weight is outside the scope of the controller
    // -> grab directly
    this.weightElement = document.querySelector(this.weightSelectorValue)

    this.weightElement.addEventListener("input", this.calculate)

    this.calculate()
  }
  disconnect() {
    this.weightElement.removeEventListener("input", this.calculate)
  }

  calculate() {
    const weight = this.weightElement.value
    const previousWeight = this.previousWeightTarget.value
    const value =
      weight && previousWeight
        ? Math.round(((weight - previousWeight) / previousWeight) * 100 * 10) /
            10 +
          "%"
        : ""

    this.outputTarget.innerText = value
  }
}
