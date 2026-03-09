import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  connect() {
    this.setup()
  }

  disconnect() {
    this.cleanup()
  }

  setup() {
    this.cleanup()

    this.search = this.search.bind(this)
    this.slimSelect = new SlimSelect({
      select: this.element,
      settings: {
        searchHighlight: true,
        hideSelectedOption: true,
        allowDeselect: false,
        maxValuesShown: 100,
        searchingText: "Searching...",
        searchPlaceholder: this.placeholder,
      },
      events: {
        search: this.debouncePromise(this.search, 250),
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
        .then((data) => {
          resolve(this.normalizeOptions(data))
        })
        .catch(() => reject("Sorry, there was a server error"))
    })
  }

  searchUrl(searchTerm) {
    return this.optionsUrl.replace("REPLACEME", encodeURIComponent(searchTerm))
  }

  normalizeOptions(data) {
    return data
      .map((option) => this.normalizeOption(option))
      .filter((option) => option !== null)
  }

  normalizeOption(option) {
    const value = option.value || option.id
    if (value === undefined || option.text === undefined) return null
    const normalizedValue = String(value)

    return {
      id: normalizedValue,
      text: option.text,
      value: normalizedValue,
    }
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

  get hint() {
    return this.element.dataset.hint || "Enter at least 3 characters"
  }

  get optionsUrl() {
    return this.element.dataset.optionsUrl || this.element.getAttribute("data-ajax--url")
  }

  get placeholder() {
    return this.element.dataset.placeholder || "Search by patient name or hospital/NHS no."
  }
}
