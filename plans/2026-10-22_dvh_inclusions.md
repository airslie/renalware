# DVH inclusions: porting renalware-dvh host app additions into renalware-dev

Source reviewed: `../renalware-dvh` (Rails 6.0 host app on the `dvh` branch of the old engine).

## 1. Already in renalware-dev: ENV configuration only, no code

| DVH setting (`config/initializers/renalware_core.rb`) | renalware-dev equivalent |
|---|---|
| `patient_hospital_identifiers` (KCH, QEH, DVH, ...) | `PATIENT_HOSPITAL_IDENTIFIERS` JSON |
| Legacy letters (`Legacy::Letter`, controller, views, summary part, clinical summary insertion) | `RENALWARE_LEGACY_LETTERS_ENABLED=true` (`Renalware::Legacy::*`) |
| `ResearchPolicy` override: anyone can manage participations | `RESEARCH_ANYONE_CAN_MANAGE_PARTICIPATIONS=true` |
| `batch_printing_enabled`, `max_batch_print_size` | `BATCH_PRINTING_ENABLED`, `MAX_BATCH_PRINT_SIZE` |
| `use_rolling_comorbidities = false` | `USE_ROLLING_COMORBIDITIES=false` |
| `session_register_user_user_activity_after` | `SESSION_REGISTER_USER_USER_ACTIVITY_AFTER` |
| `display_feedback_banner` | `DISPLAY_FEEDBACK_BANNER` |
| Microsoft Graph mail delivery | `MAIL_DELIVERY_METHOD=microsoft_graph_api` |
| `pathology_acr_obx_code_for_kfre_calculation = "ACRA"` | verify it is ENV driven (config accessor exists, used by `Pathology::KFRE::Listener`) |
| Hospital name/address/phone on letters | `HOSPITAL_*`, `PHONE_NUMBER_ON_LETTERS`, `RENAL_UNIT_ON_LETTERS` |

To check for the legacy letters: `renalware.legacy_letters` in dev has an extra
`legacy_letter_author_id` column. DVH's table lives in schema `renalware_kch`, so the rows need a
data copy into `renalware.legacy_letters` during cutover.

## 2. Code to port, each behind an off-by-default switch

### A. EPR PDF export with XML metadata sidecar (letters and MDT events)
DVH files: `ElectronicPublicRegister::{LetterListener,EventListener,PdfLetterFilename,PdfMdtFilename}`,
`Letters::SavePdfLetterToFileJob`, `Events::SavePdfEventToFileJob`, `views/{letters,events}/metadata.xml.slim`.

- Letter: on `letter_completed`, for patients with a DVH hospital number, write
  `<id>_Renal_Outpatient_Letter_<ts>_<MRN7>_<FAMILY>_<DOB>_CO03.011.pdf` plus a `.xml` sidecar
  (KWFileDetails) to `<EPR_LETTERS_FOLDER>/tmp/dvh` and `<...>/archive/dvh`.
- Event: on `event_created` where `event_type.save_pdf_to_electronic_public_register?`, same
  with `MDT_Meeting_Notes` / `CL06.080`, to `<EPR_EVENTS_FOLDER>/tmp` and `/archive`.
- renalware-dev already has `Letters::SavePdfLetterToFileJob` and `Events::SavePdfEventToFileJob`
  (no sidecar, nothing calls them). DVH's versions render via `Renalware::Letters::LetterPresenter`
  and `PdfRenderer`; dev uses `RendererFactory.renderer_for(letter, :pdf)` and the event PDF class
  moved, so the jobs need adapting, not copying.
- Beware: dev's `CreateEvent` already queues `QueueForDocumentRepositoryExport` (Mirth/HL7) for the same
  `save_pdf_to_electronic_public_register` flag. That is gated by `feeds_outgoing_documents_enabled`
  and must stay false for DVH, otherwise MDT events go to both paths.
- Proposed structure: new namespace `Renalware::EPR` (`app/models/renalware/epr/`) with filename
  builders, a sidecar XML presenter and the two listeners. Hardcoded values (activity `361`,
  doc types, `KWFileDetails` layout) become config (`EPR_*` ENV) with the DVH values documented in
  `.env.example`. `config/initializers/renalware.rb` registers the listeners only when
  `Renalware.config.epr_export_enabled` (`EPR_EXPORT_ENABLED`). Note `Letters::CompleteLetter`
  has no key in `broadcast_subscription_map` yet, so it needs adding conditionally.
- Move MRN zero-padding (`rjust(7, "0")`) into the builders.
- Moving files from tmp to the shares (`epr.sh`) is handled outside renalware-dev.

### B. Email approved letter to the patient's practice
DVH: `LetterDelivery::LetterListener#letter_approved` calls `Letters::Delivery::EmailLetterToPractice`
unless `SKIP_EMAIL_LETTERS_TO_PRACTICE=true`. The class already exists in dev.
Port as a listener on `Renalware::Letters::ApproveLetter`, registered only when
`Renalware.config.email_approved_letters_to_practice` (`EMAIL_APPROVED_LETTERS_TO_PRACTICE`, default
false). This inverts the DVH polarity, so the DVH env sets it to true. Use `deliver_later` as today.
Check this does not overlap `SEND_GP_LETTERS_OVER_MESH` and the existing electronic-CC flow.

### C. EGFR adjustment: dropped (no longer required, per DVH guidance)

## 3. Not porting
- `Letters::LettersToThePatientWithUnsentGpCc`, `letters:send_queued_gp_emails`, `email_later` column,
  `AddViewOutstandingLetterEmails`: the DB view was replaced by `select 1` in 2019 and the model
  hardcodes `renalware_dvh.` schema. Dead.
- `DatabaseHousekeeping`: dev already has `housekeeping.rake` and scheduled jobs. Verify the
  retention windows (UKRDC log 2 months, HD log 2 weeks, system visits/events 6 months) are covered, and
  port only the gaps.
- Kaminari patch (dev uses Pagy), `BaseController`/`ApplicationController`/`BasePolicy` shims,
  `main_app` method_missing helper, Delayed Job/Capistrano/whenever/monit/party_foul/exception_notification,
  secrets.yml, `Legacy`/`Letters` table prefix modules, `db/data` and `db/migrate` history.
- Login page `_warning` partial: DVH uses the default.
- Empty override partials (`_site_specific_actions`, `_site_specific_links`, `_more_help_items`).

## 4. Cutover and data (not code)
- DVH data lives in schemas `renalware`, `renalware_dvh`, `renalware_kch`, and `anemex`
  (Rails 6.0, `structure.sql`). Dev expects a single `renalware` schema. Needs a migration path.
- Use the same approach as the other hospitals already moved to the monolith.
- Confirm Good Job queues replace Delayed Job for `pdf_generation`.

## 5. Order of work (TDD, one PR each)
1. ENV-only config and `.env.example` documentation for DVH (section 1), then verify legacy letters.
2. B: practice email listener (smallest).
3. A: EPR letters, then EPR events.

## Decisions (2026-10-22)
All switches default off. Data and schema moves are handled at deployment. The `dvh` branch of
renalware-dev holds no DVH-specific engine changes beyond what `main` already has.
