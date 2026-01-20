import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    let grid = this.element
    let rowHeight =  parseInt(window.getComputedStyle(grid).getPropertyValue('grid-auto-rows'))
    let rowGap = parseInt(window.getComputedStyle(grid).getPropertyValue('grid-row-gap'));

    this.contentTargets.forEach(el => {
      let rowSpan = Math.ceil((el.querySelector(".content").getBoundingClientRect().height + rowGap) / (rowHeight + rowGap)) + 1
      el.style.gridRowEnd = "span " + rowSpan;
    })
  }
}
