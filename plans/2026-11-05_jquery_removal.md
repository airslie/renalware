# jQuery removal plan

Follows ADR-0002 (incremental migration). Goal: delete `jquery-rails`, `jquery_nested_form`/`nested_form`, Foundation 5 JS and `jquery-readyselector`, so that `core.js` (Sprockets) can be retired.

## 1. Where jQuery lives today

jQuery 2 is loaded via `app/assets/javascripts/renalware/core.js` (Sprockets, `defer`), alongside the Rollup/Stimulus bundle (`renalware.js`, ES module). Stimulus controllers reach it via `window.$`.

jQuery-dependent things loaded by `core.js`:
- `jquery2`, `jquery-readyselector` (vendor)
- `rails-ujs` (not jQuery-dependent itself, but `Rails.enableElement` is used by dialogs.js)
- Foundation 5 JS: core, alert, dropdown, reveal, tab, tooltip (hard jQuery dependency)
- `jquery_nested_form` (gem `nested_form`) and `cocoon` (cocoon needs jQuery)
- Plain libs that do not need jQuery: iframeResizer, clipboard, masonry, print-js, trix. (iframeResizer exposes `$.fn.iFrameResize` when jQuery is present.)

### Sprockets components (`app/assets/javascripts/renalware/components/`)

| File | Lines | jQuery use | Notes |
|---|---|---|---|
| ajax_errors.js | 13 | `$(document).on` | trivial |
| configuration.js | 20 | `$.extend` | trivial; global `Renalware.Configuration` also read from `application.js` (both Sprockets and Rollup) |
| feed_only_inputs.js | 23 | `$()` select + `.prop`, ready | trivial; only gated on config flag (default false) |
| feeds.js, pdf.js | 9/21 | none | already vanilla |
| iframe.js | 3 | `$('iframe.fullsize').iFrameResize()` | 1 view (letters/show) |
| tabs.js | 18 | `$` selectors, show/hide, classes | used by 5 layouts (`.sub-nav.with-tabs`) |
| toggler.js | 64 | `$` selectors, toggle, `.each` | used via `toggle_helper.rb` and many views; calls `Renalware.MasonryHelper.refresh()` |
| forms.js | 39 | click handler + `initClockpickersIn` | clockpicker is a jQuery plugin (742-line vendored file) |
| hd.js | 49 | `$.ajax` poll, `.html/.hide/.show` | duplicate of letters.js poller |
| letters.js | 154 | `$.ajax`, `$.getScript`, delegated events, `.data` | duplicates hd.js poller; depends on contacts.js Modal |
| contacts.js, problems.js | 189/157 | `$.ajax`, `$.each`, `$.getScript`, Foundation modal | near-duplicates of each other. `add-new-contact` trigger is not referenced in any view (probable dead code); `add-new-problem` is used in problems/index |
| pd.js | 45 | delegated click, clone select/checkbox values; nested_form event `nested:fieldAdded:bags` | tied to `nested_form` gem |
| dialogs.js | 27 | `$(document).foundation(...)`, `opened.fndtn.reveal`, `Rails.enableElement` | Foundation Reveal glue |
| clockpicker.js | 742 | jQuery plugin | replace with `<input type=time>` or flatpickr (already a dependency) |
| masonry.run.js | 145 | check | vanilla Masonry, verify |

### Stimulus controllers using `window.$`
- `hd/prescription_administration_controller.js` — `.toggle`/`.toggleClass` only (5 lines)
- `pd/pet_charts_controller.js` — `$.getJSON` only
- `patients/primary_care_physician_search_controller.js` — `$.ajax` + `$(modal).on/off("opened.fndtn.reveal")`
- `problems/search_controller.js` — check for `opened.fndtn.reveal` binding (same pattern)

### Server-rendered `.js.erb` (62 files)
Patterns counted: `$(..).html` ×25, `.foundation('reveal','open'|'close')` ×15, `.replaceWith` ×5, `.remove` ×5, `$.getScript` ×3, `Renalware.Letters/HD.pollBatchStatus` ×2, plus a handful of `.data/.trigger/.show/.focus/.fadeOut/.append`. This is the largest, riskiest surface because every one is tied to Rails UJS `remote: true` responses (157 files reference remote/Rails).

### Other jQuery-coupled things
- Foundation Reveal: 58 `reveal-modal`, 31 `data-reveal` usages in views; `data-dropdown` ×29; `data-tab` ×25; tooltips.
- `nested_form`: 2 `nested_form_for`, 1 `link_to_add_association`/`remove_association`, used for PD regime bags; cocoon also loaded (check whether anything uses it; likely removable).
- `spec/system` is Playwright-driven; Stimulus-style specs exist for several of the areas above (pd regime bags, problems, patients worries, clinics visits).
- JS unit tests: `node --test spec/javascript/*.test.cjs` (CI `verify.yml`), only for `helpers/timing.js` today.

## 2. Strategy

Work by dependency seam, smallest first, each PR independently shippable and covered by a system spec (or a new node unit test for pure helpers). Vanilla DOM / Stimulus; no new jQuery.

Keep jQuery loaded until the last Foundation / nested_form / clockpicker consumer is gone. Everything before that is "stop calling `$` from our own code".

### Phase 0 — Guard rails (1 PR)
- Add a lint/CI check (grep or ESLint `no-restricted-globals`/`no-restricted-syntax`) that fails on new `$(`/`jQuery` in changed files outside an allowlist file listing legacy paths. The allowlist only shrinks. Implements the ADR's follow-up item.
- Inventory script: `bin/jquery_usage` printing counts per file, to track progress.

### Phase 1 — Leaf components with no plugin dependence
Small, mechanical, low risk (see §3).

### Phase 2 — Shared helpers and duplicated code
- Extract one `pollBatchStatus` Stimulus controller or ES helper (letters + hd), `fetch` based. Replace the two `.js.erb` callers.
- Replace `$.getScript(url)` with Turbo Streams / `fetch` + render. 3 call sites.
- Remove the dead contacts.js trigger code; port problems.js "add problem" modal to a Stimulus controller (shares code with `problems/search_controller`).

### Phase 3 — Foundation Reveal modals (the big seam)
- Introduce a tiny `modal` Stimulus controller wrapping native `<dialog>` with the same open/close API and an event (`modal:opened`) replacing `opened.fndtn.reveal`.
- Keep a compatibility shim so existing `.js.erb` calls `$(sel).foundation('reveal','close')` keep working, then convert the 15 `.js.erb` callers to Turbo Streams (`turbo_stream.update`, a `close_modal` custom action) one controller at a time (patients/alerts, admissions/requests, messaging, hd/prescription_administrations, letters/*...).
- Migrate `data-reveal-id` links (31) once the shim exists.
- Delete `foundation.reveal`, `dialogs.js`.

### Phase 4 — Remaining Foundation widgets
Order: alert (trivial) → tooltip (balloon-css already a dependency) → tab (`tabs.js` + Stimulus tabs) → dropdown (`@stimulus-components/dropdown` already installed). Then delete foundation core JS.

### Phase 5 — Plugins
- `nested_form` / cocoon: replace with a Stimulus `nested-form` controller (template + add/remove + `nested:fieldAdded` equivalent event); migrate the PD regime bags form first (it has the most coverage), then drop the `nested_form` gem if no other users.
- clockpicker: replace with `<input type="time">` or flatpickr (time-only). Delete `clockpicker.js` and `_clockpicker.css`.
- iframeResizer: use the non-jQuery build's `iFrameResize()` global.

### Phase 6 — Removal
- Remove `//= require jquery2`, `jquery-readyselector`, `jquery_nested_form`, `cocoon`, Foundation JS from `core.js`; drop `jquery-rails` from Gemfile; delete `vendor/assets/javascripts/renalware/jquery-readyselector.js`, `rollup.config.js` `globals.jquery`, `window.$` consts.
- If `core.js` then only holds rails-ujs, clipboard, masonry, print-js, trix, iframeResizer: move those to the Rollup bundle and retire Sprockets JS entirely (`renalware/core` include in the layout, `application.js`).
- Re-evaluate `rails-ujs` vs `@hotwired/turbo` (data-remote/`data-confirm` replacements) as a separate piece of work.

## 3. Candidate first removals (small, low risk, testable)

Ordered by recommendation. Each is a single-file (plus view where noted) change with no plugin involved.

**Status (2026-11-05):** items 1, 3 and 4 below are done (4 turned out to be dead code and was deleted). Others pending.

1. **`ajax_errors.js`** (13 lines) — `$(document).on("ajax:error", ...)` → `document.addEventListener("ajax:error", ...)`. Event detail is already read via `event.detail`, so behaviour is identical. Test: system spec with a stubbed failing remote request (401 reloads, 500 alert), or leave it to manual since no jQuery-specific semantics.
2. **`feed_only_inputs.js` + `configuration.js`** — `$.extend` → `Object.assign`; `$("input,textarea,select").filter(...)` → `document.querySelectorAll("input[data-controlled-by-tissue-typing-feed], ...")`; ready → `DOMContentLoaded`. Test: system spec on `transplants/registrations` form with the config flag on, asserting inputs are disabled (flag default is false, so this is only visible in a test using `Renalware.config`).
3. **`forms.js` multi-submit handler** (the first block only; leave clockpicker for later) — delegated click listener using `closest`/`querySelectorAll`. Used on HD session new/edit. Test: system spec on HD session form clicking one of the buttons and asserting the other is disabled and lost `data-disable-with`.
4. **`tabs.js`** — DONE: deleted, no `.sub-nav.with-tabs` element exists in any view (the `with-tabs` class is only on `.non-patient-page-header`). Original suggestion: port to vanilla (`querySelectorAll`, `classList`, `hidden`/`style.display`). 18 lines, used in layouts. Test: system spec on an admin page with tabs (authoring snippets dialog) switching tabs. Watch out: `$(el).show()` restores the default display, so use `style.display = ""`.
5. **`toggler.js`** — port the three togglers to a delegated listener (also works for dynamically added rows, a small improvement). Highest usage of the five (66 files mention "toggler"), so ship it after 1–4 with a system spec on one table with `table-toggler`. Keep `Renalware.MasonryHelper.refresh()` call.
6. **Stimulus `hd/prescription_administration_controller.js`** — replace the 5 `.toggle/.toggleClass` calls with `hidden` classes/`style.display`; drop `const $ = window.$`. Covered by existing HD prescription administration specs (check `spec/system/renalware/hd`).
7. **`pd/pet_charts_controller.js`** — `$.getJSON` → `fetch(...).then(r => r.json())`. Check for a PET chart spec; add one if absent.
8. **`iframe.js`** — only if the non-jQuery `iFrameResize` entrypoint works; otherwise defer to Phase 5.

Items 1–4 and 6–7 can be done as independent PRs without touching Foundation or `.js.erb`; each deletes some `$` and shrinks the allowlist from Phase 0.

## 4. Risks / watch points
- Sprockets scripts are `defer` and execute before the ES module; `Renalware.*` globals are shared between the two bundles. Converting a component must keep the same global name until all callers (`.js.erb`) are converted.
- `$(document).ready` fires once; with Turbo, any new `DOMContentLoaded` listener will not rerun on Turbo visits. Prefer delegated listeners or Stimulus `connect()` (also fixes latent bugs).
- jQuery's `.show()/.hide()/.toggle()` handle `display` restoring; replacement must not leave `display: block` on table rows (`tr`) — use `hidden` or `style.display = ""`.
- `.js.erb` responses execute via rails-ujs `remote: true`; do not convert JS and view in separate releases.
- `foundation` events (`opened.fndtn.reveal`) are jQuery events, so native `addEventListener` will not receive them until the Reveal replacement exists (affects `primary_care_physician_search_controller` and `dialogs.js`).

## 5. Definition of done
- `grep -rE '\$\(|jQuery|window\.\$' app packs` returns nothing outside vendored third-party files.
- `jquery-rails`, `nested_form`, `cocoon` removed from Gemfile and `core.js`.
- Foundation JS removed (CSS may remain until the Tailwind migration finishes).
- Full RSpec system suite green.
