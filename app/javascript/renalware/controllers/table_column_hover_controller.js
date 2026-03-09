import { Controller } from "@hotwired/stimulus"

/*
When this is controller is added to a table, if the table uses colgroups (eg historical pathology)
then as the mouse enters and leaves
*/
export default class extends Controller {
  connect() {
    this.handleMouseEnter = this.highlightColgroup.bind(this)
    this.handleMouseLeave = this.unhighlightColgroup.bind(this)

    this.element.addEventListener("mouseenter", this.handleMouseEnter, true)
    this.element.addEventListener("mouseleave", this.handleMouseLeave, true)
  }

  disconnect() {
    this.element.removeEventListener("mouseenter", this.handleMouseEnter, true)
    this.element.removeEventListener("mouseleave", this.handleMouseLeave, true)
  }

  highlightColgroup(event) {
    const colgroup = this.colgroupForEvent(event)
    if (colgroup) {
      colgroup.classList.add("hover")
    }
  }

  unhighlightColgroup(event) {
    const colgroup = this.colgroupForEvent(event)
    if (colgroup) {
      colgroup.classList.remove("hover")
    }
  }

  colgroupForEvent(event) {
    const cell = event.target.closest("td")
    if (!cell || !this.element.contains(cell)) return null

    return this.element.querySelectorAll("colgroup")[cell.cellIndex] || null
  }
}
