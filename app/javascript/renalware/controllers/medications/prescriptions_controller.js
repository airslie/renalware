import { Controller } from "@hotwired/stimulus"

// Handles the modal dialog used for presenting Home Delivery print options to
// the user. Used on the prescriptions page.
export default class extends Controller {
  static targets = [ "homeDeliveryDates", "providers" ]

  connect() {
    let radio_value = this.providersTarget.querySelector("input:checked").value
    this.toggleDeliveryDatesVisibility(radio_value)
  }

  toggleDeliveryDates(event) {
    this.toggleDeliveryDatesVisibility(event.target.value)
  }

  selectHdDefaultProvider(event) {
    if (!event.target.checked) return

    const defaultProviderForHd = this.providersTarget.querySelector("input[data-default-for='hd']")
    if (!defaultProviderForHd || defaultProviderForHd.checked) return

    defaultProviderForHd.checked = true
    defaultProviderForHd.dispatchEvent(new Event("change", { bubbles: true }))
  }

  toggleDeliveryDatesVisibility(radio_value) {
    if (radio_value == "home_delivery") {
      this.homeDeliveryDatesTarget.style.display = "block"
    } else {
      this.homeDeliveryDatesTarget.style.display = "none"
    }
  }
}
