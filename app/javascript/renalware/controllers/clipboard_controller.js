// From https://github.com/stimulus-components/stimulus-clipboard

import { Controller } from "@hotwired/stimulus"

export default class Clipboard extends Controller {
  static targets = ["button", "source"]
  static values = {
    successContent: String,
    successDuration: {
      type: Number,
      default: 2000
    }
  }

  connect() {
    if (!this.hasButtonTarget) return

    this.originalContent = this.buttonTarget.innerHTML
  }

  copy(event) {
    event.preventDefault()

    const text = this.sourceTarget.innerHTML || this.sourceTarget.value

    navigator.clipboard.writeText(text).then(() => this.copied())
  }

  copied() {
    if (!this.hasButtonTarget) return

    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.buttonTarget.innerHTML = this.successContentValue

    this.timeout = setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalContent
    }, this.successDurationValue)
  }
}
