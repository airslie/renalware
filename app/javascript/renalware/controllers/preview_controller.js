import { Controller } from "@hotwired/stimulus"
import { debounce } from "../helpers/timing"

export default class extends Controller {
  static targets = ["turboframe"]
  static values = {
    src: String,
    queryParam: String,
  }

  initialize() {
    this.change = debounce(this.change.bind(this), 1000)
  }

  change(e) {
    const url = new URL(this.srcValue)
    url.searchParams.set(this.queryParamValue, e.target.value)
    this.turboframeTarget.src = url.toString()
  }
}
