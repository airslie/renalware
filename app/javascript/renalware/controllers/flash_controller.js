import { Controller } from "@hotwired/stimulus"

// Inspired by https://www.youtube.com/watch?v=gk_qDsKMIrM&t=528s
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  dismiss() {
    this.element.remove()
  }
}
