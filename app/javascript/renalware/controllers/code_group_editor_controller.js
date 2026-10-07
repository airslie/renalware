import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Drag-and-drop editor for pathology code groups. Dragging rewrites the hidden subgroup and
// position fields and asks the server to refresh the (unsaved) preview.
export default class extends Controller {
  static targets = ["list"]
  static values = { draftUrl: String }

  connect() {
    this.sortables = this.listTargets.map((list) =>
      Sortable.create(list, {
        group: "code-group-memberships",
        handle: ".handle",
        draggable: ".membership",
        animation: 150,
        onEnd: () => this.renumber(),
      })
    )
  }

  disconnect() {
    this.sortables?.forEach((sortable) => sortable.destroy())
    clearTimeout(this.timer)
  }

  queuePreview() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.refreshPreview(), 600)
  }

  async refreshPreview() {
    const response = await fetch(this.draftUrlValue, {
      method: "POST",
      body: new FormData(this.element),
      headers: { Accept: "text/html" },
    })
    const html = await response.text()
    const fresh = new DOMParser().parseFromString(html, "text/html").getElementById("code-group-preview")
    const current = document.getElementById("code-group-preview")
    if (fresh && current) current.replaceChildren(...fresh.childNodes)
  }

  renumber() {
    this.listTargets.forEach((list) => {
      const subgroup = list.dataset.subgroup
      const rows = Array.from(list.querySelectorAll(".membership"))
      rows.forEach((row, index) => {
        row.querySelector("[data-field='subgroup']").value = subgroup
        row.querySelector("[data-field='position']").value = index + 1
      })
      list.querySelector(".empty")?.classList.toggle("hidden", rows.length > 0)
    })
    this.queuePreview()
  }
}
