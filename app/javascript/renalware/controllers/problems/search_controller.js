import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  static targets = ["select", "snomedField", "snomedHint"]

  connect() {
    this.handleFormReset = this.handleFormReset.bind(this)
    this.handleModalOpened = this.handleModalOpened.bind(this)
    this.handleModalClosed = this.handleModalClosed.bind(this)
    this.formElement?.addEventListener("reset", this.handleFormReset)
    this.bindModalEvents()
    this.setup()
  }

  disconnect() {
    this.formElement?.removeEventListener("reset", this.handleFormReset)
    this.unbindModalEvents()
    this.cleanup()
  }

  setup() {
    this.cleanup()

    this.search = this.search.bind(this)
    this.slimSelect = new SlimSelect({
      select: this.selectTarget,
      settings: {
        searchHighlight: true,
        allowDeselect: false,
        searchingText: "Searching...",
        searchPlaceholder: this.placeholder,
        searchText: this.hint,
      },
      events: {
        search: this.debouncePromise(this.search, 250),
        addable: (value) => this.buildFreeTextOption(value),
        afterChange: (newValue) => {
          this.updateSnomed(newValue[0])
        },
      },
    })
    this.initialData = this.cloneData(this.slimSelect.getData())
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
        .then((data) => resolve(this.normalizeOptions(data.problems || [])))
        .catch(() => reject("Sorry, there was a server error"))
    })
  }

  searchUrl(searchTerm) {
    const url = new URL(this.optionsUrl, window.location.origin)
    url.searchParams.set("term", searchTerm)
    return url.toString()
  }

  normalizeOptions(data) {
    return data
      .map((option) => this.normalizeOption(option))
      .filter((option) => option !== null)
  }

  normalizeOption(option) {
    const value = option.value || option.id || option.text
    if (value === undefined || option.text === undefined) return null
    const code = option.code || ""

    return {
      id: String(value),
      value: String(value),
      text: option.text,
      html: this.optionHtml(option.text, code),
      data: {
        code,
      },
    }
  }

  updateSnomed(option) {
    if (!this.hasSnomedFieldTarget || !this.hasSnomedHintTarget) return

    const selectedOption = this.selectTarget.selectedOptions[0]
    const snomedId =
      option?.data?.code ||
      option?.code ||
      selectedOption?.dataset?.code ||
      ""
    this.snomedFieldTarget.value = snomedId

    if (snomedId.length > 0) {
      this.snomedHintTarget.querySelector("strong").textContent = snomedId
      this.snomedHintTarget.classList.remove("hidden")
      this.snomedHintTarget.style.display = ""
    } else {
      this.snomedHintTarget.classList.add("hidden")
      this.snomedHintTarget.style.display = "none"
    }
  }

  handleFormReset() {
    requestAnimationFrame(() => {
      this.resetSearchState()
    })
  }

  handleModalOpened() {
    requestAnimationFrame(() => {
      this.slimSelect?.open()
    })
  }

  handleModalClosed() {
    this.resetSearchState()
  }

  buildFreeTextOption(value) {
    return {
      id: value,
      value,
      text: value,
      html: this.optionHtml(value, ""),
      data: {
        code: "",
      },
    }
  }

  optionHtml(text, code) {
    const escapedText = this.escapeHtml(text)
    if (code.length > 0) {
      return `${escapedText} <span class="problem-option">${this.escapeHtml(code)}</span>`
    }

    return `${escapedText} <span class="problem-freetext-option">free text</span>`
  }

  escapeHtml(value) {
    const div = document.createElement("div")
    div.textContent = value
    return div.innerHTML
  }

  bindModalEvents() {
    if (!this.modalElement) return

    $(this.modalElement).on("opened.fndtn.reveal", this.handleModalOpened)
    $(this.modalElement).on("closed.fndtn.reveal", this.handleModalClosed)
  }

  unbindModalEvents() {
    if (!this.modalElement) return

    $(this.modalElement).off("opened.fndtn.reveal", this.handleModalOpened)
    $(this.modalElement).off("closed.fndtn.reveal", this.handleModalClosed)
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

  resetOptions() {
    if (!this.slimSelect) return

    this.slimSelect.setData(this.cloneData(this.initialData || []))
  }

  resetSearchState() {
    this.resetOptions()
    this.slimSelect?.setSelected("")
    this.slimSelect?.search("")
    this.updateSnomed(null)
  }

  cloneData(data) {
    return JSON.parse(JSON.stringify(data || []))
  }

  get optionsUrl() {
    return this.selectTarget.dataset.optionsUrl
  }

  get hint() {
    return this.selectTarget.dataset.hint || "Enter at least 3 characters"
  }

  get placeholder() {
    return this.selectTarget.dataset.placeholder || "Search by problem name."
  }

  get formElement() {
    return this.element.closest("form")
  }

  get modalElement() {
    return this.element.closest("[data-reveal]")
  }
}
