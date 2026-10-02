# Plan: Continue where you left off after re-authenticating

**Date**: 2026-10-01

## Overview
When a session times out (or, with Entra ID, the user is made to re-authenticate) the user should
be able to carry on from the page they were on rather than always landing on their dashboard,
without exposing that page to a different user signing in on the same browser.

## Problems found in the previous behaviour
- `SessionsController#after_sign_in_path_for` compared `last_sign_in_at` with the 30 minute
  memory period. Devise's trackable has already moved `last_sign_in_at` to the start of the
  *previous session* by then, so anyone who had worked for more than ~10 minutes before timing out
  was sent to the dashboard.
- Entra ID / LDAP sign-ins (`OmniauthCallbacksController`) ignored the memory period entirely.
- The remembered URL (`user_return_to`) belonged to the browser session, so a different user
  signing in on a shared PC was sent to the previous user's page.
- Edit/new pages were resumed even though anything typed in them had been lost.

## Phase 1 (done)
- `Renalware::Devise::FailureApp` (configured in `config/initializers/devise.rb`): on a timeout it
  stores `{user_id, path, expired_at}` under `session["renalware.resume_location"]` instead of
  Devise's `user_return_to`. A `Warden::Manager.before_logout` hook captures the timed-out user and
  their `last_request_at`, because Devise resets the session before the failure app runs.
- Every timed-out request is recorded, not just page loads. If the session expires during a
  background (XHR/JSON/Turbo Frame) request or a form submission, the record is *pending* and
  the next full page load (the JS reload, or the redirect back to the form) fills in the page.
  While a record exists Devise's own `user_return_to` is never stored. A blank path means there is
  nowhere to resume (eg a form with no page above it), so the user goes to their dashboard.
- Paths keep any engine mount point (eg `/research/studies`); only the app's
  `relative_url_root` is stripped before route recognition.
- `expired_at` is `last_request_at + Devise.timeout_in`, so the memory period runs from when the
  session actually expired, not when the timeout was noticed.
- `Users::ResumablePath`: only routable GET pages are resumable; Devise/auth and keep-alive
  endpoints are not; `new`/`edit` pages map to the nearest routable page above them, skipping the
  `show` page of a singular resource being edited (eg transplant workups, which redirect back to
  their form when nothing has been saved).
- `Users::ResumeLocation#consume_for(user)`: returns the path only to the same user within
  `Renalware.config.duration_of_last_url_memory_after_session_expiry` (30 minutes), and always
  forgets it.
- `Concerns::ResumeAfterSignIn` is shared by the sessions and OmniAuth callbacks controllers.
- Signed-out visitors following a deep link are still returned to it via Devise's `user_return_to`.

## Phase 2: warn before timeout (done)
- `Renalware::SessionExpiryWarning` (Phlex) renders a `<dialog>` in the layout for signed-in
  users. `session_controller.js` opens it `Renalware.config.session_timeout_warning` before the
  server expiry (env `SESSION_TIMEOUT_WARNING`, ISO8601, default `PT2M`, `PT0S` switches it off;
  capped at half the session timeout), with a live countdown and a "Session expiring" tab title.
- "Stay signed in" (or Escape) sends a keep-alive; the new expiry is broadcast to other tabs, which
  close their warnings. "Log out" signs out of every open tab.
- Activity is only registered with the server on a throttle (2 minutes by default), so activity
  just before expiry used to be lost. When the warning is due and there is unregistered activity,
  it is registered immediately instead of warning a user who is evidently still there.
- When a background tab regains focus the warning is re-evaluated, as its timers may be delayed.

## Phase 3: per-user, tiered resume
- Persist the resume location per user in the database (survives browser restarts and session
  resets, and suits Entra ID).
- Tiers (configurable): redirect straight back if recent; show a dismissible "Continue where you
  left off: <patient> – <area>" banner on the dashboard for the rest of the day/shift; discard
  after that. Build the label server-side; do not store patient details in the browser.
