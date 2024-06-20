import { Controller } from "@hotwired/stimulus"

// From https://www.stimulus-components.com/docs/stimulus-popover
export default class Popover extends Controller {
  static targets = ["card", "content"]
  static values = {
    url: String
  }

  async show(event) {
    // Temporally variable to prevent `event.currentTarget` to being null.
    const element = event.currentTarget

    let content = null

    if (this.hasContentTarget) {
      content = this.contentTarget.innerHTML
    } else {
      content = await this.fetch()
    }

    if (!content) return

    const fragment = document.createRange().createContextualFragment(content)
    element.appendChild(fragment)
  }

  hide() {
    if (this.hasCardTarget) {
      this.cardTarget.remove()
    }
  }

  async fetch() {
    if (!this.remoteContent) {
      if (!this.hasUrlValue) {
        console.error(
          "[stimulus-popover] You need to pass an url to fetch the popover content."
        )
        return
      }

      const response = await fetch(this.urlValue)
      this.remoteContent = await response.text()
    }

    return this.remoteContent
  }
}
