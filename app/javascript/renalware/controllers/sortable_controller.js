import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

//
// Inspired by https://gorails.com/episodes/rails-drag-and-drop-sortable
//
// Annotate html as follows:
//
// <div data-controller="sortable" data-sortable-url=move_some_resource_path(id: ":id")>
//   <% items.each do |item| %>
//     <div data-id=item.id>...</div>
//   <% end %>
// </div>

export default class extends Controller {
  static values = {
    url: String,
    rel: String,
  }

  connect() {
    this.container = this.element.tagName === "TABLE" ? this.element.tBodies[0] : this.element
    if (!this.container) return

    this.sortable = Sortable.create(this.container, {
      handle: ".handle",
      draggable: ".sortable",
      animation: 150,
      onEnd: this.end.bind(this),
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }

  end(event) {
    if (this.hasUrlValue) return this.persistByResource(event)
    if (this.relEndpoint()) return this.persistBySerializedIds(event.item)
  }

  persistByResource(event) {
    const id = event.item.dataset.id
    if (!id) return

    const body = new URLSearchParams({ position: event.newIndex + 1 }).toString()
    this.request(this.urlValue.replace(":id", id), "PATCH", body)
  }

  async persistBySerializedIds(item) {
    const rel = this.relEndpoint()
    const serialised = this.serialiseIds()
    if (!rel || !serialised.query) return

    const response = await this.request(rel, "POST", serialised.query)
    if (!response?.ok) return

    const ids = await this.responseBody(response)
    this.highlight(item)
    this.updateSortOrderIndicators(ids)
  }

  serialiseIds() {
    const items = Array.from(this.container.querySelectorAll(".sortable[id]"))
    const parsed = items.map((item) => this.parseDomId(item.id)).filter(Boolean)
    if (parsed.length === 0) return { query: null, paramKey: null }

    const paramKey = parsed[0].paramKey
    const ids = parsed.filter((item) => item.paramKey === paramKey).map((item) => item.id)
    const encodedKey = encodeURIComponent(`${paramKey}[]`)
    const query = ids.map((id) => `${encodedKey}=${encodeURIComponent(id)}`).join("&")

    return { query: query, paramKey: paramKey }
  }

  parseDomId(domId) {
    const matched = domId.match(/^(.*)[_-](\d+)$/)
    if (!matched) return null

    return { paramKey: matched[1], id: matched[2] }
  }

  relEndpoint() {
    return this.relValue || this.element.dataset.sortableRelValue
  }

  updateSortOrderIndicators(ids) {
    if (typeof ids === "string") {
      try {
        ids = JSON.parse(ids)
      } catch (_error) {
        return
      }
    }

    if (!Array.isArray(ids) || ids.length === 0) return

    ids.forEach((modelId, index) => {
      const selector = `.sortable-position-for-model-id-${modelId}`
      this.element.querySelectorAll(selector).forEach((cell) => {
        cell.innerHTML = index + 1
      })
    })
  }

  highlight(element) {
    if (!element) return

    element.classList.add("post-action-highlight")
    window.setTimeout(() => {
      element.classList.remove("post-action-highlight")
    }, 1600)
  }

  async request(url, method, body) {
    return new Promise((resolve) => {
      const request = new XMLHttpRequest()
      request.open(method, url, true)

      Object.entries(this.headers()).forEach(([key, value]) => {
        request.setRequestHeader(key, value)
      })

      request.onreadystatechange = () => {
        if (request.readyState !== 4) return

        resolve({
          ok: request.status >= 200 && request.status < 300,
          status: request.status,
          headers: {
            get: (name) => request.getResponseHeader(name),
          },
          json: async () => JSON.parse(request.responseText || "null"),
          text: async () => request.responseText,
        })
      }

      request.send(body)
    })
  }

  headers() {
    return {
      Accept: "application/json, text/javascript, */*; q=0.01",
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
      "X-CSRF-Token": this.csrfToken(),
      "X-Requested-With": "XMLHttpRequest",
    }
  }

  csrfToken() {
    return document.querySelector("meta[name='csrf-token']")?.getAttribute("content") || ""
  }

  async responseBody(response) {
    const contentType = response.headers.get("content-type") || ""
    if (contentType.includes("application/json")) return response.json()
    return response.text()
  }
}
