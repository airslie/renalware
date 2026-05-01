import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]
  static values = { formSelector: String }

  connect() {
    this.updateRequestForm()
  }

  uncheckAll(event) {
    event.preventDefault()

    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = false
    })
    this.updateRequestForm()
  }

  toggle() {
    this.updateRequestForm()
  }

  updateRequestForm() {
    if (!this.requestForm) return

    this.hiddenPatientIdInputs.forEach((input) => input.remove())
    this.checkedPatientIds.forEach((patientId) => {
      this.requestForm.appendChild(this.buildHiddenPatientIdInput(patientId))
    })
  }

  buildHiddenPatientIdInput(patientId) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "request[patient_ids][]"
    input.value = patientId
    return input
  }

  get checkedPatientIds() {
    return this.checkboxTargets
      .filter((checkbox) => checkbox.checked)
      .map((checkbox) => checkbox.value)
      .filter((patientId, index, patientIds) => patientIds.indexOf(patientId) === index)
  }

  get hiddenPatientIdInputs() {
    return this.requestForm.querySelectorAll(
      'input[name="request[patient_ids][]"]'
    )
  }

  get requestForm() {
    return document.querySelector(this.formSelectorValue)
  }
}
