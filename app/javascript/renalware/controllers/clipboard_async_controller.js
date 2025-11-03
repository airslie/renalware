import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["status", "button"]

  async copy(event) {
    const btn = event.currentTarget
    btn.disabled = true

    try {
      // console.log(`Fetching from ${this.urlValue}`)

      // Try modern ClipboardItem API with delayed promise (Chrome/Edge)
      if (navigator.clipboard && window.ClipboardItem) {
        try {
          const textPromise = fetch(this.urlValue, { credentials: "same-origin", headers: { "Accept": "text/plain" } })
            .then(res => {
              if (!res.ok) throw new Error(`HTTP ${res.status}`)
              return res.blob()
            })

          const clipboardItem = new ClipboardItem({ "text/plain": textPromise })
          await navigator.clipboard.write([clipboardItem])

          this.showTooltip(btn, "Copied!")
          this.updateStatus("Copied to clipboard.")
          return
        } catch (clipboardError) {
          console.warn("ClipboardItem failed, falling back:", clipboardError)
        }
      }

      // Fallback: fetch then use textarea method (Safari, Firefox)
      const res = await fetch(this.urlValue, { credentials: "same-origin", headers: { "Accept": "text/plain" } })
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const text = await res.text()

      await this.writeToClipboardFallback(text)

      this.showTooltip(btn, "Copied!")
      this.updateStatus("Copied to clipboard.")
    } catch (e) {
      console.error(e)
      this.showTooltip(btn, "Copy failed")
      this.updateStatus("Copy failed. You can open the Show page and copy manually.")
    } finally {
      setTimeout(() => {
        btn.disabled = false
      }, 1200)
    }
  }

  showTooltip(btn, message) {
    // Create floating tooltip appended to body
    const tooltip = document.createElement("div")
    tooltip.textContent = message
    tooltip.className = "floating-tooltip"

    // Position near button
    const rect = btn.getBoundingClientRect()
    tooltip.style.left = `${rect.left + rect.width / 2}px`
    tooltip.style.top = `${rect.bottom + 8}px`
    tooltip.style.transform = "translateX(-50%)"

    document.body.appendChild(tooltip)

    // Remove after animation
    setTimeout(() => {
      tooltip.style.transition = "opacity 0.2s"
      tooltip.style.opacity = "0"
      setTimeout(() => tooltip.remove(), 200)
    }, 1000)
  }

  async writeToClipboardFallback(text) {
    // Fallback: hidden textarea + execCommand
    const ta = document.createElement("textarea")
    ta.value = text
    // Avoid scrolling on iOS Safari
    ta.style.position = "fixed"
    ta.style.top = "-1000px"
    ta.setAttribute("readonly", "")
    document.body.appendChild(ta)
    ta.select()
    ta.setSelectionRange(0, ta.value.length)

    const ok = document.execCommand("copy")
    document.body.removeChild(ta)
    if (!ok) throw new Error("execCommand copy failed")
  }

  updateStatus(msg) {
    if (this.hasStatusTarget) this.statusTarget.textContent = msg
  }
}
