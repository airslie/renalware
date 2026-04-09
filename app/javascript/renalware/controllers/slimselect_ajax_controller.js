import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  static values = { }

  connect() {
    this.setup()
  }

  disconnect(event) {
    this.cleanup()
  }

  setup(event) {
    this.cleanup()
    this.go = this.go.bind(this);
    const options = {
      select: this.element,
      events: {},
      settings: {
        searchHighlight: true,
        hideSelectedOption: true,
        allowDeselect: false,
        maxValuesShown: 100
      }
    }

    if (this.optionsUrl) {
      options.settings.searchingText = 'Searching...'
      options.events = {
        search: this.debouncePromise(this.go, 200),
        afterOpen: () => {
          this.slimSelect.search('')
        }
      }
    }
    this.slimSelect = new SlimSelect(options)
  }

  cleanup (event) {
    if (!this.slimSelect) return
    this.slimSelect.destroy()
    delete this.slimSelect
  }

  go(searchTerm, currentData) {
    return new Promise((resolve, reject) => {
      if (searchTerm.length < 3) {
        reject("Search term must be at least 3 characters");
        return;
      }
      const url = this.optionsUrl.replace('REPLACEME', searchTerm);

      fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        },
      })
      .then((response) => response.json())
      .then(data => {
        resolve(this.mergeOptions(this.normalizeOptions(data), currentData));
      })
      .catch(error => reject("Sorry, there was a server error"))
    });
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
      value: normalizedValue,
      text: option.text,
      selected: option.selected || false
    }
  }

  mergeOptions(newOptions, currentData) {
    const merged = new Map()

    newOptions.forEach((option) => {
      merged.set(option.value, option)
    })

    currentData
      .map((option) => this.normalizeOption(option))
      .filter((option) => option !== null)
      .forEach((option) => {
        if (!merged.has(option.value)) {
          merged.set(option.value, option)
        }
      })

    return Array.from(merged.values())
  }

  debouncePromise(func, wait) {
    let timeout;
    return function (...args) {
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

  get addable () {
    return this.element.dataset.addable === 'true'
  }

  get allowDeselect () {
    return this.element.dataset.allowDeselect === 'true'
  }

  get optionsUrl () {
    return this.element.dataset.optionsUrl
  }

  get placeholder () {
    return this.element.getAttribute('placeholder')
  }
}
