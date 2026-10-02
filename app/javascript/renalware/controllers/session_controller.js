
const Rails = window.Rails
const _ = window._
import { Controller } from "@hotwired/stimulus"

// This controller handles session keepalive, timeout detection and cross-tab
// logout signalling.
//
// Design notes:
// - Keep server requests minimal: extend session on throttled user activity.
// - Do one expiry check when we expect timeout, not periodic polling.
// - If the tab regains focus after expected expiry, reconcile once with server.
// - Keep server as source of truth for session expiry.
// - Warn the user shortly before expiry so they can choose to stay signed in, unless they have
//   been active since the session was last extended, in which case just extend it.
export default class extends Controller {
  static targets = ["warningDialog", "countdown"]

  logoutEventStorageKey = "logout-event"
  sessionExpiryEventStorageKey = "session-expiry-event"
  checkForSessionExpiryTimeout = null
  initialSessionExpiryAtEpochMs = null
  sessionExpiryAtEpochMs = null
  keepAlivePath = null
  loginPath = null
  throttledRegisterUserActivity = null
  sessionTimeoutSeconds = 0
  defaultSessionTimeoutSeconds = 20 * 60 // 20 mins
  throttlePeriodSeconds = 0
  defaultThrottlePeriodSeconds = 20
  networkRetryDelaySeconds = 30
  warnBeforeSeconds = 0
  warningTimeout = null
  countdownInterval = null
  activityPending = false
  titleBeforeWarning = null

  initialize() {
    this.throttlePeriodSeconds = parseInt(
      this.data.get("register-user-activity-after") || this.defaultThrottlePeriodSeconds,
      10
    )
    this.sessionTimeoutSeconds = parseInt(
      this.data.get("timeout") || this.defaultSessionTimeoutSeconds,
      10
    )
    this.sessionTimeoutSeconds += 10 // To allow for network roundtrips etc
    this.initialSessionExpiryAtEpochMs = parseInt(this.data.get("expires-at-epoch-ms"), 10)
    this.loginPath = this.data.get("login-path")
    this.keepAlivePath = this.data.get("keep-alive-path")
    this.warnBeforeSeconds = parseInt(this.data.get("warn-before") || "0", 10)
    this.boundUserActivity = this.userActivity.bind(this)
    this.boundStorageChange = this.storageChange.bind(this)
    this.boundVisibilityChange = this.visibilityChange.bind(this)
    this.boundWindowFocus = this.windowFocus.bind(this)
    this.logSettings()

    // We only need to register activity occasionally; trailing debounce keeps
    // requests low while still extending the session for active users.
    this.throttledRegisterUserActivity = _.throttle(
      this.registerUserActivity.bind(this),
      this.throttlePeriodSeconds * 1000,
      { "leading": false, "trailing": true }
    )
  }

  connect() {
    if (this.onLoginPage) {
      this.log("connect: onLoginPage - skipping session time")
    } else {
      this.addHandlersToMonitorUserActivity()
      if (Number.isFinite(this.initialSessionExpiryAtEpochMs)) {
        this.setSessionExpiryFromServer(this.initialSessionExpiryAtEpochMs)
      } else {
        this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds)
      }
    }
  }

  disconnect() {
    if (!this.onLoginPage) {
      this.removeUserActivityHandlers()
      this.clearCheckForSessionExpiryTimeout()
      this.throttledRegisterUserActivity.cancel()
      this.clearWarningTimeout()
      this.hideWarning()
    }
  }

  sendLogoutMessageToAnyOpenTabs() {
    window.localStorage.setItem(this.logoutEventStorageKey, "logout" + Math.random())
  }

  broadcastSessionExpiryToAnyOpenTabs(expiresAtEpochMs) {
    window.localStorage.setItem(
      this.sessionExpiryEventStorageKey,
      JSON.stringify({ expires_at_epoch_ms: expiresAtEpochMs, nonce: Math.random() })
    )
  }

  // Event handler for key/click/resize. We note the activity and register it with the server
  // at most once per throttle period, or sooner if the expiry warning becomes due.
  userActivity() {
    this.activityPending = true
    this.throttledRegisterUserActivity()
  }

  // Throttled handler: the user has interacted with the page within throttlePeriodSeconds
  registerUserActivity() {
    this.log("some activity detected")
    this.activityPending = false
    this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds)
    this.sendRequestToKeepSessionAlive()
  }

  // Timeout handler for checking if the session has expired
  resetCheckForSessionExpiryTimeout(intervalSeconds) {
    this.setSessionExpiryAtEpochMs(Date.now() + intervalSeconds * 1000)
  }

  setSessionExpiryAtEpochMs(expiresAtEpochMs) {
    if (!Number.isFinite(expiresAtEpochMs)) return

    this.clearCheckForSessionExpiryTimeout()
    this.sessionExpiryAtEpochMs = expiresAtEpochMs
    const delayMs = Math.max(expiresAtEpochMs - Date.now(), 0)
    this.log(`resetting session expiry timeout ${delayMs / 1000}`)
    this.checkForSessionExpiryTimeout = setTimeout(this.checkForSessionExpiry.bind(this), delayMs)
    this.scheduleWarning()
  }

  scheduleWarning() {
    this.clearWarningTimeout()
    if (this.warnBeforeSeconds <= 0 || !this.hasWarningDialogTarget) return

    const delayMs = this.sessionExpiryAtEpochMs - this.warnBeforeSeconds * 1000 - Date.now()
    if (delayMs <= 0) {
      this.warningDue()
    } else {
      this.hideWarning()
      this.warningTimeout = setTimeout(this.warningDue.bind(this), delayMs)
    }
  }

  clearWarningTimeout() {
    clearTimeout(this.warningTimeout)
    this.warningTimeout = null
  }

  // Activity not yet registered with the server would be lost when the session expires, so
  // register it now rather than warning a user who is evidently still here.
  warningDue() {
    if (this.activityPending) {
      this.log("warning due but user has been active - extending session")
      this.throttledRegisterUserActivity.cancel()
      this.registerUserActivity()
    } else {
      this.showWarning()
    }
  }

  showWarning() {
    if (!this.warningDialogTarget.open) {
      this.log("showing session expiry warning")
      this.warningDialogTarget.showModal()
      this.titleBeforeWarning = document.title
      document.title = `Session expiring - ${this.titleBeforeWarning}`
    }
    this.updateCountdown()
    clearInterval(this.countdownInterval)
    this.countdownInterval = setInterval(this.updateCountdown.bind(this), 1000)
  }

  hideWarning() {
    clearInterval(this.countdownInterval)
    this.countdownInterval = null
    if (!this.hasWarningDialogTarget || !this.warningDialogTarget.open) return

    this.warningDialogTarget.close()
    if (this.titleBeforeWarning !== null) document.title = this.titleBeforeWarning
    this.titleBeforeWarning = null
  }

  updateCountdown() {
    if (!this.hasCountdownTarget) return

    const remainingSeconds = Math.max(Math.ceil((this.sessionExpiryAtEpochMs - Date.now()) / 1000), 0)
    const minutes = Math.floor(remainingSeconds / 60)
    const seconds = String(remainingSeconds % 60).padStart(2, "0")
    this.countdownTarget.textContent = `${minutes}:${seconds}`
  }

  // Action for the warning's "Stay signed in" button, and for dismissing it with Escape.
  // The current expiry is suspended while the keep-alive is in flight, as reloading at that
  // expiry would lose unsaved work if the server extends the session but responds slowly. The
  // keep-alive response sets the new expiry; if none arrives we reconcile with the server later.
  staySignedIn(event) {
    event.preventDefault()
    this.hideWarning()
    this.activityPending = false
    this.throttledRegisterUserActivity.cancel()
    this.clearWarningTimeout()
    this.clearCheckForSessionExpiryTimeout()
    this.checkForSessionExpiryTimeout = setTimeout(
      this.checkForSessionExpiry.bind(this),
      this.networkRetryDelaySeconds * 1000
    )
    this.sendRequestToKeepSessionAlive()
  }

  // Server returns absolute epoch time. If that value is already in the past
  // relative to the browser clock (eg local clock skew or test time travel),
  // avoid immediate reload loops and use a relative timeout instead.
  setSessionExpiryFromServer(expiresAtEpochMs) {
    if (!Number.isFinite(expiresAtEpochMs)) return

    if (expiresAtEpochMs <= Date.now()) {
      this.log("server expiry is in the past for this browser clock; using relative timeout")
      this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds)
      return
    }

    this.setSessionExpiryAtEpochMs(expiresAtEpochMs)
  }

  clearCheckForSessionExpiryTimeout() {
    clearTimeout(this.checkForSessionExpiryTimeout)
    this.checkForSessionExpiryTimeout = null
  }

  // When the local timer says the session has expired we reload. The server remains
  // source of truth and will either redirect to login or keep user on page.
  checkForSessionExpiry() {
    this.sendLogoutMessageToAnyOpenTabs()
    window.location.reload()
  }

  sendRequestToKeepSessionAlive() {
    this.ajaxGet(this.keepAlivePath, {
      onSuccess: this.onKeepAliveSucceeded.bind(this),
      onError: this.onKeepAliveFailed.bind(this)
    })
  }

  ajaxGet(path, { onSuccess = null, onError = null } = {}) {
    Rails.ajax({
      type: "GET",
      url: path,
      dataType: "json",
      success: (responseData, status, xhr) => {
        if (onSuccess) onSuccess(responseData, status, xhr)
      },
      error: (responseText, status, xhr) => {
        if (!this.reloadPageIfAjaxRequestWasUnauthorised(responseText, status, xhr) && onError) {
          onError(xhr)
        }
      }
    })
  }

  onKeepAliveSucceeded(responseData) {
    const expiresAtEpochMs = this.extractExpiresAtEpochMs(responseData)
    if (expiresAtEpochMs) {
      this.setSessionExpiryFromServer(expiresAtEpochMs)
      this.broadcastSessionExpiryToAnyOpenTabs(expiresAtEpochMs)
      return
    }

    // Fallback if a proxy/middleware strips JSON.
    this.resetCheckForSessionExpiryTimeout(this.sessionTimeoutSeconds)
  }

  onKeepAliveFailed(xhr) {
    if (xhr.status !== 401) {
      this.log(`keepalive failed (${xhr.status}); retrying`)
      this.resetCheckForSessionExpiryTimeout(this.networkRetryDelaySeconds)
    }
  }

  extractExpiresAtEpochMs(responseData) {
    if (!responseData || !responseData.expires_at_epoch_ms) return null

    const value = parseInt(responseData.expires_at_epoch_ms, 10)
    return Number.isFinite(value) ? value : null
  }

  reloadPageIfAjaxRequestWasUnauthorised(responseText, status, xhr) {
    if (xhr.status === 401) {
      window.location.reload()
      this.sendLogoutMessageToAnyOpenTabs()
      return true
    }

    return false
  }

  addHandlersToMonitorUserActivity() {
    document.addEventListener("click", this.boundUserActivity)
    document.addEventListener("mousedown", this.boundUserActivity)
    document.addEventListener("keydown", this.boundUserActivity)
    window.addEventListener("resize", this.boundUserActivity)
    window.addEventListener("storage", this.boundStorageChange)
    document.addEventListener("visibilitychange", this.boundVisibilityChange)
    window.addEventListener("focus", this.boundWindowFocus)
  }

  removeUserActivityHandlers() {
    document.removeEventListener("click", this.boundUserActivity)
    document.removeEventListener("mousedown", this.boundUserActivity)
    document.removeEventListener("keydown", this.boundUserActivity)
    window.removeEventListener("resize", this.boundUserActivity)
    window.removeEventListener("storage", this.boundStorageChange)
    document.removeEventListener("visibilitychange", this.boundVisibilityChange)
    window.removeEventListener("focus", this.boundWindowFocus)
  }

  logSettings() {
    if (this.debug) {
      this.log(`keepAlivePath ${this.keepAlivePath}`)
      this.log(`initialSessionExpiryAtEpochMs ${this.initialSessionExpiryAtEpochMs}`)
      this.log(`loginPath ${this.loginPath}`)
      this.log(`sessionTimeoutSeconds ${this.sessionTimeoutSeconds}`)
      this.log(`warnBeforeSeconds ${this.warnBeforeSeconds}`)
      this.log(`throttlePeriodSeconds ${this.throttlePeriodSeconds}`)
    }
  }

  log(msg) {
    if (this.debug) {
      console.log(msg)
    }
  }

  // An event handler to watch for changes in localStorage.
  // We use localStorage as a cross-tab communication protocol: when the user has
  // logged out of one tab, this mechanism is used to signal to any other logged-in tabs that they
  // should log themselves out.
  // This applies in 2 circumstances:
  // - the user has clicked the "Log Out" link in the navbar - the sendLogoutMessageToAnyOpenTabs()
  //   action defined above is called
  // - our tab has timed out due to inactivity; other open tabs may still think they are active, so
  //   we give them a nudge.
  storageChange(event) {
    if (event.key === this.logoutEventStorageKey) {
      setTimeout(() => window.location.reload(), 500)
    } else if (event.key === this.sessionExpiryEventStorageKey) {
      const expiresAtEpochMs = this.extractExpiresAtEpochMs(this.parseStorageEventPayload(event.newValue))
      if (expiresAtEpochMs) this.setSessionExpiryFromServer(expiresAtEpochMs)
    }
  }

  parseStorageEventPayload(value) {
    try {
      return JSON.parse(value || "{}")
    } catch {
      return {}
    }
  }

  visibilityChange() {
    if (document.visibilityState === "visible") {
      this.reconcileSessionWhenReturningToTab()
    }
  }

  windowFocus() {
    this.reconcileSessionWhenReturningToTab()
  }

  // Timers in background tabs can be delayed, so re-check the expiry and warning on return.
  reconcileSessionWhenReturningToTab() {
    if (!this.sessionExpiryAtEpochMs) return

    if (Date.now() < this.sessionExpiryAtEpochMs) {
      this.scheduleWarning()
    } else {
      this.checkForSessionExpiry()
    }
  }

  get onLoginPage() {
    return window.location.pathname == this.loginPath
  }

  // If you add data-session-debug=1 then logging will be enabled
  // This is evaluated each time we can add debugging into a running page
  get debug() {
    return this.data.get("debug") === "true"
  }
}
