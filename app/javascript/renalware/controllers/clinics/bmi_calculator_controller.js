import { Controller } from "@hotwired/stimulus"

/*  Single use controller only for the Dietetic Clinic Visit */

export default class extends Controller {
  static targets = ["output"]

  static values = {
    weightSelector: String,
    heightSelector: String,
  }

  initialize() {
    this.calculate = this.calculate.bind(this)
  }

  connect() {
    // As the weight and the height are outside the scope of the controller
    // -> grab them directly
    this.weightElement = document.querySelector(this.weightSelectorValue)
    this.heightElement = document.querySelector(this.heightSelectorValue)

    this.heightElement.addEventListener("input", this.calculate)
    this.weightElement.addEventListener("input", this.calculate)

    this.calculate()
  }
  disconnect() {
    this.heightElement.removeEventListener("input", this.calculate)
    this.weightElement.removeEventListener("input", this.calculate)
  }

  calculate() {
    const weight = this.weightElement.value
    const height = this.heightElement.value
    const value =
      weight && height
        ? (Math.round((weight / height / height) * 10) / 10).toFixed(1)
        : ""

    this.outputTarget.innerText = value
  }
}
