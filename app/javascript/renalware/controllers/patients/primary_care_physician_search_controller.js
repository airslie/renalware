import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  connect() {
    this.handleModalOpened = this.handleModalOpened.bind(this)
    this.bindModalEvents()
    this.setup()

    // The modal content may connect after Foundation has already opened it.
    requestAnimationFrame(() => {
      if (this.isVisible) this.slimSelect?.open()
    })
  }

  disconnect() {
    this.unbindModalEvents()
    this.cleanup()
  }

  setup() {
    this.cleanup()

    this.search = this.search.bind(this)
    this.slimSelect = new SlimSelect({
      select: this.element,
      settings: {
        searchHighlight: true,
        allowDeselect: false,
        searchingText: "Searching...",
        searchPlaceholder: this.placeholder,
        searchText: this.hint,
      },
      events: {
        search: this.debouncePromise(this.search, 250),
        afterChange: (newValue) => {
          const practiceId = newValue[0]?.value
          if (practiceId) this.refreshForm(practiceId)
        },
        afterOpen: () => {
          this.slimSelect.search("")
        },
      },
    })
  }

  cleanup() {
    if (!this.slimSelect) return

    this.slimSelect.destroy()
    delete this.slimSelect
  }

  search(searchTerm) {
    return new Promise((resolve, reject) => {
      if (searchTerm.length < 3) {
        reject(this.hint)
        return
      }

      fetch(this.searchUrl(searchTerm), {
        method: "GET",
        headers: {
          Accept: "application/json",
        },
      })
        .then((response) => response.json())
        .then((data) => resolve(this.normalizeOptions(data)))
        .catch(() => reject("Sorry, there was a server error"))
    })
  }

  searchUrl(searchTerm) {
    const url = new URL(this.optionsUrl, window.location.origin)
    url.searchParams.set("q", searchTerm)
    return url.toString()
  }

  normalizeOptions(data) {
    return data
      .map((option) => this.normalizeOption(option))
      .filter((option) => option !== null)
  }

  normalizeOption(option) {
    const value = option.value || option.id
    if (value === undefined || option.name === undefined) return null

    const text = option.name
    const address = option.address ? ` ${option.address}` : ""

    return {
      id: String(value),
      value: String(value),
      text,
      html: `<b>${this.escapeHtml(text)}</b>&nbsp;${this.escapeHtml(address).trimStart()}`,
    }
  }

  refreshForm(practiceId) {
    $.ajax(this.formRefreshUrl, {
      type: "GET",
      dataType: "script",
      data: {
        practice_id: practiceId,
      },
    })
  }

  handleModalOpened() {
    requestAnimationFrame(() => {
      this.slimSelect?.open()
    })
  }

  bindModalEvents() {
    if (!this.modalElement) return

    $(this.modalElement).on("opened.fndtn.reveal", this.handleModalOpened)
  }

  unbindModalEvents() {
    if (!this.modalElement) return

    $(this.modalElement).off("opened.fndtn.reveal", this.handleModalOpened)
  }

  debouncePromise(func, wait) {
    let timeout

    return (...args) => {
      clearTimeout(timeout)

      return new Promise((resolve, reject) => {
        timeout = setTimeout(() => {
          func(...args)
            .then(resolve)
            .catch(reject)
        }, wait)
      })
    }
  }

  escapeHtml(value) {
    const div = document.createElement("div")
    div.textContent = value
    return div.innerHTML
  }

  get optionsUrl() {
    return this.element.dataset.optionsUrl || this.element.getAttribute("data-options-url")
  }

  get formRefreshUrl() {
    return this.element.dataset.formRefreshUrl || this.element.getAttribute("data-form-refresh-url")
  }

  get hint() {
    return this.element.dataset.hint ||
      this.element.getAttribute("data-hint") ||
      "Enter first few letters of practice name or its postcode"
  }

  get placeholder() {
    return this.element.dataset.placeholder ||
      this.element.getAttribute("data-placeholder") ||
      "Search for a practice"
  }

  get modalElement() {
    return this.element.closest("[data-reveal]")
  }

  get isVisible() {
    return this.element.offsetParent !== null
  }
}
