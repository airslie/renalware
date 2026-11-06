# Relay: sharing GP Connect delivery between Renalware and a new app

Status: discussion draft, 2026-11-06. Based on a read of the current GP Connect / MESH code on
`chore/gp_connect_relay_groundwork`. TransferOfCare code ignored as requested.

## 1. What we actually have today

The GP Connect "Send Document" workflow is a MESH transport plus a FHIR STU3 payload builder:

| Piece | Where | Renalware-specific? |
|---|---|---|
| MESH API client (auth header, certs, send, inbox, download, ack, handshake, endpointlookup) | `letters/transports/mesh/api/*` | No. Pure protocol, but reads `Renalware.config` |
| ITK3 inf/bus response parsing | `mesh/api/itk3_response.rb`, `response_headers.rb` | No |
| FHIR payload (Bundle, MessageHeader, Composition, Patient, Practitioner, Organisation, Binary) | `letters/formats/fhir/**` | Mostly no. Takes a `Transmission`, reaches through to `Letter` |
| Operation logging (every API call stored with raw req/resp) | `mesh/api/log_operation.rb`, `letter_mesh_operations` | No in concept, but FK chain leads to `letter_letters` |
| Jobs: SendMessage, CheckInbox, DownloadMessage, Handshake, Reconcile | `app/jobs/.../mesh/*` | Reconcile is: it writes `letters.gp_send_status` and calls `CompleteLetter` |
| Trigger | `ApproveLetter` calls `QueueLetterDelivery` and `set_gp_send_status` directly | Yes |
| Admin UI (transmissions, operations, inbox, unreconciled, jobs, bulk/test-case tools) | `controllers/.../mesh/*` | Generic. Relay needs all of it |
| Config | `Renalware.config.mesh_*` global singleton | Single tenant by design |

Key observation: **the real input to GP Connect is small.** Patient demographics, author name,
sender organisation, a SNOMED document type, approval time, a document UUID and PDF bytes. With
MESH auto-routing (`mex_to` = `GPPROVIDER_<nhs>_<dob>_<surname>`, the default) we do not need
practice or GP data at all. That is exactly what HOSPA's HL7 message would carry, so there is a
natural neutral boundary.

## 2. Design problems to fix before (or while) sharing

1. **Transport code writes clinical state.** `ReconcileOperationsJob` does
   `update_columns(gp_send_status: ...)` and runs `CompleteLetter`. The delivery layer must emit
   an outcome and let the host decide what to do with it. This is the single most important seam.
2. **Eligibility logic is copied in three places** (`ApproveLetter#send_to_gp_using_mesh?`,
   `QueueLetterDelivery#send_to_gp_using_mesh?`, `SendMessageJob#validate_arguments`).
3. **`send_gp_letters_over_mesh` is a boolean doing three jobs**: enables sending, sets
   `gp_send_status` to pending or not_applicable, and drives `printable_gp_send_statues`
   (when false, everything is printable). We need a tri-state, e.g.
   `gp_letter_delivery = :none | :builtin_mesh | :relay`.
4. **Pending letters silently drop off the print list.** `printable_gp_send_statues` excludes
   `pending`, and the no-response timeout is `P20D`. If Relay is down, or a callback is lost,
   a GP copy stays "pending" and unprinted for up to 20 days. With Relay in the loop we need a
   fail-safe in Renalware itself (see 5.4).
5. **Global single-tenant config.** Org name/ODS/UUID, care setting (hard-coded
   "Nephrology service"), mailbox, certs, workflow ID. `composition_title` is hard-coded
   "Consultation report" and `document_version` is hard-coded 1. All must become per-sender or
   per-document-type data.
6. **`API::Client#ssl_options` sets `verify: false`.** This disables server certificate
   verification, so the `ca_file` is not enforced. Fix before copying it into a second app.
7. **PHI duplication.** `letter_mesh_operations` stores the raw outbound payload (base64 PDF) and
   responses indefinitely. Relay will hold other departments' PHI, so it needs a retention policy
   (e.g. purge payloads after N days, keep metadata).
8. **Single MESH mailbox, destructive inbox.** `DownloadMessageJob` acknowledges messages, which
   removes them from the inbox. If Renalware and Relay both poll the same mailbox they will
   consume and ack each other's responses. Unmatched ones are logged as `reconciliation_error`,
   but the response is gone. **Relay must have its own mailbox**, and exactly one poller per
   mailbox, always.
9. **Mixed granularity in `letter_mesh_operations`.** Handshake and check_inbox are mailbox-level
   (no transmission), while send/download/ack are per transmission. In Relay these should be two
   concepts (mailbox health vs delivery attempts).
10. **Wire-format regressions are the real risk.** The payload is NHS-assured. Any refactor
    needs golden-file specs (fixed inputs produce the same XML, modulo UUIDs/timestamps) before
    code moves.

## 3. Options for sharing the code

| | Description | Pros | Cons |
|---|---|---|---|
| A. Copy/fork | Copy MESH code into Relay | Fast | Two assured implementations that drift. No |
| B. Protocol gem | Gem (`relay-gpconnect`) with FHIR builders, MESH client, ITK3 parsing, and a pure outcome evaluator. **No ActiveRecord, no jobs, no UI.** Each host owns storage and orchestration | Shares the assured wire logic, the thing that must not diverge. No shared schema, no data migration for HOSPA production. Small API surface | State machine, jobs, and admin UI exist twice (Renalware keeps its own, Relay builds its own) |
| C. Full Rails engine | Models, migrations, jobs, UI in an engine mounted by both | Maximum reuse | Shared migrations across two schemas (Renalware uses a `renalware` PG schema), live table renames at HOSPA, FK to `letter_letters` must become polymorphic, two upgrade cadences locked together, UI themed twice. Highest cost |
| D. Relay-only, sidecar | Renalware always calls Relay; "built-in" mode is a single-tenant Relay container deployed beside Renalware | One implementation, one assurance story | Another service for RW-only hospitals (certs, DB schema, upgrades). Requires retiring built-in code |

### Recommendation

**B now, with D as the packaging answer if/when a second RW-only hospital appears. Avoid C.**

- Renalware keeps its existing built-in delivery (tables unchanged, nothing to migrate), but
  rebuilt on the protocol gem, behind a port (see 4).
- Relay is built on the same gem with its own database and its own state machine.
- If an RW-only hospital wants GP Connect and does not want to run a web app, the built-in mode
  still works, and stays small because the heavy lifting is in the gem. If that hospital would
  rather not manage MESH certs and polling inside Renalware, they can run Relay in single-tenant
  mode next to it (option D, using the same API Renalware uses for HOSPA).
- This answers "how do we keep the built-in solution": the gem is the shared asset, and
  persistence is deliberately not shared.

Use `git filter-repo` (or `git subtree split`) to extract with history. The gem can live in a
private repo / registry initially. Decide licence (Renalware is open source) and whether Relay is
open or closed before the gem is published anywhere.

## 4. The seam inside Renalware (do this first, it is safe)

```
Letters::DeliveryRequest (value object: patient PI, author, sender org, doc type, pdf, letter uuid)
Letters::DeliveryGateway (port)
  .submit(request) -> receipt(external_ref)
  implementations: BuiltinMeshGateway (today's code, via gem) | RelayGateway (REST)
Letters::RecordGPDeliveryOutcome.call(letter:, outcome:, detail:)
  the ONLY place that sets gp_send_status and runs CompleteLetter
```

- Eligibility (GP is a recipient, not confidentiality-restricted, mode enabled) lives in one
  predicate used by `ApproveLetter`.
- `ReconcileOperationsJob` keeps its job, but calls `RecordGPDeliveryOutcome` instead of writing
  the letter.
- `Formats::FHIR::Arguments` takes a `DeliveryRequest`, not a `Transmission`.
- Add golden-file payload specs first.

This is a pure refactor with no behaviour change at HOSPA, and it is what makes the later
Relay adapter a small addition.

## 5. Relay design sketch

### 5.1 Naming and model (not GP-specific)

- `Sender` (department/service): ODS org, display name, care setting (SNOMED + text), phone/email,
  HL7 sending application/facility mapping, allowed document types, channel rules, MESH mailbox.
- `Submission`: one inbound request (PI + PDF + doc type + source message id). Idempotency key.
- `Delivery`: one per channel/recipient. Channels: `gp_connect_mesh` now, later NHS Notify
  (letter/SMS/email to patient), secure email, "needs printing" queue.
- `Attempt`: generalisation of today's operations, per delivery.
- `DocumentType`: sender-scoped mapping from HL7 code (e.g. TXA-2) to SNOMED code/title,
  composition title and Mex-Subject template. Replaces the hard-coded "Consultation report".
- Channels are plug-ins behind one interface (`deliver`, `reconcile`), so NHS Notify is an
  addition, not a rewrite.

### 5.2 Ingress

- Relay does **not** speak MLLP. Mirth/the hospital TIE (already used by Renalware for
  `Feeds::OutgoingDocument`) converts HL7 and POSTs to Relay over HTTPS. This keeps Relay simple.
- Two adapters to one internal model: HL7 MDM^T02 (PID + TXA + OBX base64 PDF, as
  `Feeds::HL7DocumentMessageBuilder` already produces) for HOSPA departments, and a REST API
  for Renalware (richer errors, synchronous receipt, idempotency).
- The HL7 message must carry an **explicit "deliver to GP" instruction** and a confidentiality
  indicator, since Relay cannot infer these. Renalware decides this today
  (`gp_is_a_recipient?`, `confidentiality_restricted?`).

### 5.3 Feedback

- Primary: REST `GET /deliveries/:id` plus a signed webhook (HMAC) to the sender.
- HL7: app-level ACK for receipt (AA/AE). For end-to-end delivery result there is no universal
  v2 convention. Agree with HOSPA's integration team (a later MDM^T04 status message, an ORU, or
  a custom Z-message) and make it an optional Relay outbound adapter.
- Delivery states in Relay: `received, rejected, queued, submitted, delivered, failed, expired,
  cancelled`. Mapping into Renalware: received/queued/submitted -> `pending`; delivered ->
  `success`; rejected/failed/expired -> `failure`.

### 5.4 Renalware to Relay for HOSPA (the hard question)

- Config per mode: `gp_letter_delivery = :relay`. `ApproveLetter` sets `gp_send_status = pending`
  as now.
- **Transactional outbox.** Create the submission row inside the approve transaction and
  post it to Relay from a job, retried, idempotent on letter UUID. Retries exhausted ->
  `failure`, so the letter becomes printable. No silent limbo.
- **Do not rely on callbacks alone.** Webhook for speed, plus a reconcile job in Renalware that
  polls Relay for any submission still pending after N minutes. Keep a Renalware-side timeout
  (much shorter than 20 days for the Relay path) that flips to `failure`.
- Outcome goes through `RecordGPDeliveryOutcome`, so the existing "GP only recipient -> complete
  letter" behaviour is retained.
- The print list logic does not change: `success` means skip the GP copy, anything else prints.

### 5.5 Cutover at HOSPA

1. Relay gets its **own MESH mailbox** and client certificate.
2. Keep the old poller running in drain mode for in-flight transmissions. Transmissions can stay
   pending up to the 20-day timeout. Only after they settle disable the built-in path.
3. Switch is one config value per environment. Add a unique constraint (one active delivery per
   letter per channel) so a letter can never go out via both paths and send the GP a duplicate.
4. Letters created before the switch stay on the built-in path. No backfill needed.

### 5.6 Users and auth

Decision: Entra ID first, role-based, department-scoped. LDAP deferred (it cannot do OIDC, so
keep the auth layer pluggable). Reuse the Renalware stack (Devise + `omniauth-entra-id`).

**Authentication (humans)**
- OIDC authorization-code flow with PKCE; validate `iss`, `aud`, `tid`. MFA and Conditional
  Access are enforced by Entra, not by Relay. No local passwords.
- Key users by the immutable `oid` (plus `tid`), never email/UPN. Provision just-in-time on
  first login; do **not** persist roles or scopes as the source of truth. Recompute at each login.
- Absolute session lifetime (e.g. 8h) and idle timeout (e.g. 30 min), so a user removed from a
  group loses access within one session.
- One Relay instance serves exactly one Entra tenant (each hospital brings its own and gets its
  own instance). Tenant id, client id and credential are therefore deployment config, not a
  table, and `tid` is validated against that single configured value. Airslie support staff
  need guest (B2B) accounts in the hospital tenant to use the UI.
- `department_viewer` (read-only) is a role alongside `department_admin`.
- Decided: the token emits only groups assigned to the Relay Enterprise Application
  (Token configuration -> groups claim -> "Groups assigned to the application"). Relay requests
  no Graph permissions. Onboarding a department = hospital IT assigns the department group to
  the Enterprise App, then Airslie adds the `sender_access_groups` row. Still to confirm
  with HOSPA IT early.

**Authorization = role x scope (two orthogonal things)**
- *Role* (what you can do): `platform_admin`, `department_admin`, `department_viewer`, maybe
  `auditor`. Coarse, few. Best practice is Entra **App Roles** defined on the app registration
  and assigned to groups via the Enterprise Application. Your "Relay department administrators"
  overarching group is exactly this: it carries the `department_admin` app role.
- *Scope* (which departments' data): a Relay-owned table
  `sender_access_groups(sender_id, entra_group_object_id)`. A user's accessible senders = senders
  whose mapped group appears in their token. Many-to-many, so a user can cover several
  departments. Store group **object IDs**, not names.
- Permission = role AND scope. Role without any mapped group sees nothing (deny by default).
- Why not one app role per department: needs a manifest change by whoever owns the app
  registration for every new department. Why not role-only via groups: the `groups` claim is
  capped (~200 in a JWT, then "overage" and a Graph call). Mitigation: set the token
  configuration to emit **only groups assigned to the application**. Hospital IT assigns each
  department group to the Relay Enterprise App. Then no overage, no Graph permission and no
  admin-consented `Group.Read.All` is needed. Verify nested-group behaviour in HOSPA's tenant.
- The mapping table is edited by platform admins only (a department admin editing their own
  mapping is a privilege escalation). Record onboarding as a runbook: hospital IT creates the
  group and assigns it to the app, Airslie adds the mapping row.

**Enforcement**
- Central: Pundit `policy_scope` for every query, backed by `Current.accessible_sender_ids`.
  Add Postgres row-level security keyed on a per-transaction setting as a backstop, since this
  is PHI. Use UUIDs in URLs. System specs: department A cannot see B via list, direct URL,
  PDF download, search, export, or API.
- Platform admins: mailbox-level screens (handshake, inbox, unreconciled, certs, config) are
  theirs. Default to metadata-only for letters; viewing a PDF requires a reason, is logged, and
  is ideally time-boxed.
- Audit log (append-only): logins, role/scope changes, every document view/download, resend or
  cancel, config changes.

**Machine clients (not Entra users)**
- Renalware REST client, Mirth, webhooks: OAuth2 client-credentials with Entra app
  registrations (certificate or federated credential, not shared secrets), or mTLS plus
  per-sender hashed API keys if the hospital network is simpler. Optionally IP allowlist.
- The **sender identity is derived from the credential, never from the payload**, so one
  department cannot submit as another.
- Outbound webhooks are signed (HMAC) with a per-sender secret.

## 6. Migration challenges

- Moving MESH code out: mechanical but wide (jobs, scheduled jobs, config, admin UI, routes,
  policies, locales, specs, `letter_mesh_letters` view). Do the seam refactor in place first.
- Renalware tables stay (option B), so **no production data migration at HOSPA**. This is the
  main argument against option C.
- If the gem reads `Renalware.config`, introduce a `Relay::GPConnect::Config` object that the
  host populates. Do this during extraction.
- Test-case/bulk-test tooling for NHS assurance (`testcase_invocations`, `bulk_tests`) belongs in
  Relay, not Renalware, going forward.

## 6a. Decisions so far (2026-11-06)

- Relay undergoes its own NHS assurance. DCB0129 and data-processor questions still to investigate.
- One mailbox initially, but the model must support a mailbox per department: `Mailbox` is a
  first-class entity, `Sender` belongs to a mailbox, handshake/poller/certs are per mailbox.
- GP resolution stays on MESH auto-routing (no practice data needed in Relay).
- HL7 spec undecided. Relay's internal model and REST API come first; HL7 is an adapter.
- Amended letters unsupported: a revision is a new letter with a new document UUID. Relay
  rejects a resubmission of the same (sender, source document id) and returns the existing
  delivery (idempotency).
- Undelivered letters are printed manually, driven by `gp_send_status = failure`. The outbox,
  retry and short Relay-path timeout (5.4) are what guarantee that "stuck" becomes "failure".
- Failure follow-up for non-Renalware departments: each sending department is responsible for
  printing its own undelivered letters. How they find out (REST/HL7 failure notification, or
  admins checking Relay) is deliberately undecided. Design implication: every terminal
  failure is a first-class `DeliveryEvent` with a reason, and Relay exposes failures through
  one internal event stream. The UI filter, REST query, webhook and HL7 status adapters are all
  consumers of it, so any can be added later without remodelling.
- Restricted confidentiality: keep current behaviour (Renalware never electronically sends these;
  they print). Review exact rules before building. Relay should default-deny: a submission
  without an explicit confidentiality value is rejected.

## 6b. Current restricted-confidentiality behaviour (code review)

Source: `Patient#confidentiality` enum `normal | restricted` (default normal; DB comment:
"Correspondence will not be sent via GP Connect if set to restricted").

Where it is enforced:
1. `ApproveLetter#send_to_gp_using_mesh?` -> `gp_send_status = not_applicable` (so the GP copy
   is printable).
2. `Mesh::QueueLetterDelivery#send_to_gp_using_mesh?` -> no `Transmission` is created.
3. `Delivery::Email::PracticeListener` -> no email to the practice.
4. `FHIR::Arguments#confidentiality` -> "R"/"N" in the Composition. This is dead for restricted
   patients today because they never reach payload building (defence in depth only).

Gaps worth knowing about:
- **Evaluated once, at approval.** `SendMessageJob` re-checks only that GP is a recipient and
  the patient has a practice. If a patient is flagged restricted between approval and send
  (5s default delay, longer on `MissingPdfContentError` retries), the letter still goes.
- **No UI found** to set the flag (no view, form, controller or policy references it), so it is
  set outside the app (console/SQL/import). Confirm how it is really maintained.
- It is a patient-level flag only; there is no per-letter or per-document-type override.
- Specs cover cases 1, 2, 4. Nothing covers the post-approval flip.

Implications for Relay:
- Renalware keeps deciding. In `:relay` mode, restricted patients never create a submission and
  stay `not_applicable`/printed, matching today. Re-check the flag at submit time in the outbox
  job, not only at approval.
- Relay cannot see the patient flag, so the submission contract needs a **required**
  `confidentiality` field (`normal | restricted`). Relay refuses `restricted` for the GP Connect
  channel and records a `rejected` delivery with reason, and rejects missing values.
- Do not assume this rule is right for HOSPA's other departments (maternity, sexual health,
  safeguarding cases). Each sender's rule should be agreed with the hospital, and sender-side
  responsibility documented in the clinical safety case.

## 6c. Groundwork status (branch `chore/gp_connect_relay_groundwork`)

Constraint throughout: no change to production behaviour at HOSPA and no orphaned in-flight
messages. No migrations, jobs, queues or table changes were made. All commits are local, not
yet pushed or reviewed.

| Step | Addresses problem | Commit | Result |
|---|---|---|---|
| 1 | 10 (wire-format regressions) | 6a17c9c10 | Golden-file spec pins the assured XML, `Mex-To` and `Mex-Subject` |
| 2 | 2 (eligibility in 3 places) | 0d9d9adf4 | `Delivery::PrimaryCareDeliveryPolicy`, used by `ApproveLetter` and `QueueLetterDelivery` |
| 3 | 1 (transport writes clinical state) | e2f8917ba | `RecordGPDeliveryOutcome` is the only writer of `gp_send_status` after approval; the reconcile job reports outcomes to it |
| 4 | 3 (boolean doing three jobs) | ddfcc383d | `Renalware::GPLetterDelivery` (`none`, `builtin_mesh`, `relay`). `GP_LETTER_DELIVERY` wins; otherwise legacy `SEND_GP_LETTERS_OVER_MESH` maps to the same behaviour |
| 5 | 5 (partly: inputs) | 8f4dcd0ca | `DeliveryRequest` plain value object + `BuildDeliveryRequest`; the GP Connect payload builds from it with no models or config |

Notes and decisions made while doing it:
- `GPLetterDelivery` lives in `lib/` because `ScheduledJobs.config` reads it in an initializer,
  before `app/` classes autoload. Putting it in `app/` stopped the app booting.
- `GP_LETTER_DELIVERY=relay` and unknown values abort boot on purpose. A silent no-send would
  leave letters pending and hidden from the print list.
- Nested `DeliveryRequest::*` types must be assigned outside the `Data.define` block, or the
  constants leak into `Renalware::Letters` and clash with `Letters::Patient`.
- `Arguments` builds a lazy request from a letter, resolving each field on first use. This
  preserves the old reads-only-what-is-needed behaviour that existing specs rely on. A pure
  `DeliveryRequest` (Relay, gem) needs none of it.
- `SendMessageJob`'s send-time GP-recipient check was deliberately left as is (it protects
  in-flight work).
- The disabled `SEND_HOSPITAL_NUMBER_IDENTIFIERS` feature still works, from
  `local_patient_ids`.
- Two RTF specs in `spec/models/renalware/feeds/hl7_document_message_builder_spec.rb` fail
  before and after this work (unrelated).

Still open from section 2:
- **6 (`verify: false` in `API::Client#ssl_options`)**: deliberately not changed. Enabling
  verification could stop production sends if HOSPA's cert chain is not set up for it. Test
  against the MESH environment first, then fix before the code is shared.
- **4 (pending letters hidden for up to 20 days)**: needs the Relay-path timeout and outbox
  (5.4); no change to the built-in path.
- **5 (global single-tenant config, hard-coded "Consultation report", `document_version`)**:
  `sender` now travels in the request, but the config source and the hard-coded title/version
  in `Arguments` remain.
- **7 (PHI retention in `letter_mesh_operations`)**, **8 (mailbox contention)** and **9 (operation
  granularity)**: Relay-time concerns; nothing done yet.
- Extra: `Transmission.letter_id` FK and `Arguments#letter` for the unused TransferOfCare code
  keep the delivery code tied to `Letters::Letter` until the protocol layer is extracted.

### Next phase (proposed order)

1. **Investigate and fix item 6** against the MESH integration environment (own PR, behind
   confirmation that HOSPA's chain verifies).
2. **Make `Arguments` and the FHIR builders independent of `Transmission`/`Letter`** by moving
   `document_title`, `composition_title`, `document_version`, `mex_to` and workflow selection
   onto the request or a small config object. Keep TransferOfCare working or explicitly parked.
3. **Pin the MESH client and ITK3 parsing** with specs, then **extract the protocol gem**
   (payload builders, MESH client, ITK3 parsing, outcome evaluator) with history, behind a
   `Config` object instead of `Renalware.config`. Renalware consumes it; golden spec must pass
   unchanged.
4. **Add `Letters::DeliveryGateway` port** with the built-in MESH implementation, and design the
   REST contract for the Relay implementation (idempotency key = letter UUID, required
   `confidentiality`, signed webhook, polling fallback).
5. **Start Relay**: sender/mailbox/submission/delivery/attempt model, Entra auth (5.6), REST
   ingress, then HL7 adapter once HOSPA's spec exists. Own NHS assurance.
6. **Renalware outbox + `RelayGateway`**, timeout/fail-safe, `GP_LETTER_DELIVERY=relay` goes
   live only here, then HOSPA cutover per 5.5 (own mailbox, drain the old poller).

## 7. Questions to resolve (many are non-technical)

**Assurance and governance**
1. Was NHS England assurance granted to Renalware as a product/supplier? Does Relay need its own
   assurance, or is it an extension? This could dominate the timeline.
2. New clinical safety case / hazard log (DCB0129) for Relay and the new departments; hospital
   side DCB0160. Silent delivery failure is a patient safety hazard.
3. Data protection roles: is Airslie processor for HOSPA? DPIA, DSPT, DTAC, hosting location,
   retention, and who can see which department's letters.
4. Licence and repo ownership for Relay and the shared gem.

**MESH and routing**
5. Mailbox arrangement: one Relay mailbox for all departments, or one per department/ODS? Does
   HOSPA use auto-routing (`GPPROVIDER_...`) or endpoint lookup? (Default is auto-routing.)
6. Which SNOMED document types are accepted by GP Connect Send Document, and what do maternity
   and discharge summaries map to? Do care-setting values need to vary per department?

**HL7 / integration**
7. HOSPA's HL7 spec: version, message type (MDM^T02? T08 for replace?), where NHS number, GP
   instruction and confidentiality go, maximum message size with a base64 PDF in OBX.
8. Which interface engine does HOSPA run, and who owns the Relay-facing channel?
9. What do other departments need back, and in which format?

**Behaviour**
10. Amended letters: GP Connect cannot recall a delivered document. What does a revised or
    deleted letter do? (`document_version` is currently fixed at 1.)
11. Undeliverable (no NHS number, no registered GP, PDS mismatch): who gets told, and what is
    the fallback for departments that are not Renalware (print queue in Relay?).
12. Should Relay do a PDS lookup to validate NHS number and GP before sending?
13. Volumes, SLAs, and out-of-hours monitoring. Who is paged when MESH or Relay is down?
14. Maternity/safeguarding: Renalware suppresses electronic send for
    `confidentiality_restricted?` patients. HOSPA's departments need an equivalent rule.
