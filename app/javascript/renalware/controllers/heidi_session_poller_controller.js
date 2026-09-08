import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lastChecked", "noteStatus", "seenSessionIds", "supersededSessionIds", "status", "trix",
    "refreshButton", "refreshStatus", "chooser", "documentSelect", "preview", "replaceButton"]

  static values = {
    interval: { type: Number, default: 10000 },
    insertedSessionIds: { type: Array, default: [] },
    url: String,
    polling: { type: Boolean, default: true },
    sessionIds: { type: Array, default: [] },
  }

  connect() {
    const replacementPending = this.hasSupersededSessionIdsTarget && this.supersededSessionIdsTarget.value !== ""
    this.pollingStopped = !this.pollingValue || replacementPending
    if (this.pollingStopped) return
    this.poll()
    this.timer = window.setInterval(() => this.poll(), this.intervalValue)
  }

  disconnect() {
    this.stopPolling()
  }

  async poll() {
    try {
      const response = await fetch(this.urlValue, {
        credentials: "same-origin",
        headers: { "Accept": "application/json" },
      })
      if (!response.ok) return

      const body = await response.json()
      if (!body.present || this.pollingStopped) return

      this.updateStatus(body)
      if (body.synced) this.handleSyncedSession(body)
      if (this.isTerminalFailure(body.status)) this.stopPolling()
    } catch {
      // Keep polling; transient failures should not disturb the edit form.
    }
  }

  updateStatus(body) {
    if (this.hasStatusTarget) this.statusTarget.innerHTML = this.statusBadgeHtml(body)
    if (this.hasNoteStatusTarget) this.noteStatusTarget.textContent = body.consult_note_status
    if (this.hasLastCheckedTarget) this.lastCheckedTarget.textContent = body.last_synced_at
  }

  statusBadgeHtml(body) {
    const status = this.statusClassName(body.status)
    if (!status) return this.escapeHtml(body.status_label)

    return `<span class="heidi-state ${status}"><span class="heidi-state__indicator"></span><span class="heidi-state__label">${this.escapeHtml(body.status_label)}</span></span>`
  }

  statusClassName(status) {
    return {
      "preparing": "heidi-state--preparing",
      "launched": "heidi-state--launched",
      "synced": "heidi-state--synced",
      "launch_failed": "heidi-state--launch-failed",
      "sync_failed": "heidi-state--sync-failed",
    }[status]
  }

  isTerminalFailure(status) {
    return status === "launch_failed" || status === "sync_failed"
  }

  handleSyncedSession(body) {
    if (this.appendConsultNote(body)) this.markSessionSeen(body.id)
    this.stopPolling()
  }

  appendConsultNote(body) {
    if (this.noteAlreadyPresent(body)) return true
    if (!this.shouldAppendConsultNote(body)) return false

    this.trixTarget.editor.insertHTML(this.formattedConsultNote(body.consult_note))
    return true
  }

  shouldAppendConsultNote(body) {
    if (!this.hasTrixTarget) return false
    if (!this.trixTarget.editor) return false
    if (!body.consult_note) return false
    if (this.insertedSessionIdsValue.includes(body.id)) return false

    return true
  }

  noteAlreadyPresent(body) {
    if (!body.consult_note) return false

    return this.currentNoteHtml().includes(body.consult_note)
  }

  formattedConsultNote(note) {
    return note
  }

  markSessionSeen(sessionId) {
    if (!this.hasSeenSessionIdsTarget) return

    const seenSessionIds = this.seenSessionIds()
    if (seenSessionIds.includes(sessionId)) return

    this.seenSessionIdsTarget.value = [...seenSessionIds, sessionId].join(",")
    this.insertedSessionIdsValue = [...this.insertedSessionIdsValue, sessionId]
  }

  seenSessionIds() {
    return this.seenSessionIdsTarget.value
      .split(",")
      .map((id) => Number.parseInt(id, 10))
      .filter((id) => Number.isInteger(id))
  }

  currentNoteHtml() {
    return this.trixTarget.value || ""
  }

  escapeHtml(value) {
    const div = document.createElement("div")
    div.textContent = value || ""
    return div.innerHTML
  }

  async refresh(event) {
    if (this.refreshing) return
    const button = event.currentTarget
    this.refreshing = true
    this.setRefreshButtonLoading(button, true)
    this.chooserTarget.hidden = true
    this.refreshStatusTarget.textContent = ""
    this.refreshButtonTargets.forEach((button) => { button.disabled = true })
    try {
      const response = await fetch(button.dataset.url, {
        credentials: "same-origin",
        cache: "no-store",
        headers: { "Accept": "application/json" },
      })
      if (!response.ok) throw new Error("Refresh failed")
      const body = await response.json()
      this.documents = body.documents
      this.documentSelectTarget.replaceChildren(...this.documents.map((document, index) => {
        const option = new Option(document.name, index)
        return option
      }))
      this.chooserTarget.hidden = false
      this.preview()
    } catch {
      this.refreshStatusTarget.textContent = "Unable to fetch Heidi documents. Notes have not been changed. Please try again."
    } finally {
      this.refreshing = false
      this.setRefreshButtonLoading(button, false)
      this.refreshButtonTargets.forEach((button) => { button.disabled = false })
    }
  }

  setRefreshButtonLoading(button, loading) {
    button.setAttribute("aria-busy", String(loading))
    button.querySelector("[data-refresh-spinner]").classList.toggle("hidden", !loading)
    button.querySelector("[data-refresh-label]").textContent = loading ? "Checking Heidi…" : "Check for updates"
  }

  preview() {
    const document = this.documents?.[this.documentSelectTarget.value]
    this.previewTarget.innerHTML = document?.content || ""
    this.replaceButtonTarget.disabled = !document?.content
    if (!document?.content) {
      this.previewTarget.textContent = "This document is not ready. Wait for Heidi to finish generating it, then check for updates again."
    }
  }

  replaceNotes() {
    const document = this.documents?.[this.documentSelectTarget.value]
    if (!document?.content || !this.hasTrixTarget || !this.trixTarget.editor) return
    if (!window.confirm("Replace all current Notes with this Heidi document? This includes any changes you have made in Renalware.")) return

    this.stopPolling()
    this.trixTarget.editor.recordUndoEntry("Replace Notes from Heidi")
    this.trixTarget.editor.loadHTML(document.content)
    // Replacing all Notes intentionally supersedes imports from every listed session.
    this.sessionIdsValue.forEach((id) => this.markSessionSeen(id))
    this.supersededSessionIdsTarget.value = this.sessionIdsValue.join(",")
    this.chooserTarget.hidden = true
    this.refreshStatusTarget.textContent = "Notes replaced. Review and save the form to keep these changes."
  }

  cancelRefresh() {
    this.chooserTarget.hidden = true
    this.refreshStatusTarget.textContent = ""
  }

  stopPolling() {
    this.pollingStopped = true
    if (this.timer) window.clearInterval(this.timer)
    this.timer = null
  }
}
