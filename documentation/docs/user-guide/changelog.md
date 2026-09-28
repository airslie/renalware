---
title: Changelog
sidebar_position: 100
---

# CHANGELOG

#### User Guide Version History

- 05 Jun 2024: Version 1.0 (Renalware v 2.4.4) -- PDF only (Apple Pages)
- 02 Mar 2025: Version 2.0 (Renalware v 2.4.5) -- Online &amp; PDF version (using [IA Writer](https://ia.net/writer))
- 19 Dec 2025: Version 2.1 (Renalware v 2.5.4) -- Online only (using [Jekyll](https://jekyllrb.com/) & [Just The Docs](https://just-the-docs.com/))

---

#### Renalware v 2 CHANGELOG

:::note

Displaying changes starting from v 2.4.0.

:::

```
# Change Log

## 2.4.5.5
### Added
- Add a patient Timeline page and add to Clinical Summary #5379
- Add support for sending outgoing documents as RTF (Barts) #5278
- Support SIU^S14 HL7 messages #5300
- Add a unique ehr_person_identifier column to patients #5300
  - This is a future-proofing step as eg Millennium has a person id that _could_ be send in HL7 and stored by us.
- Display user's name and roles at top of dashboard #5303
  - This change is to satisfy the MESH API assurance requirements that when logged, the user's name and role/s are displayed, in addition to last login/failed login date times.
- Show failed login attempt when more recent than last login #5328
- Handle async REPORT messages from MESH API #5304
  E.g. undeliverable after 5 days. These have no body, just headers.
- If a patient is undeceased via HL7, notify superadmins via message #5305
  - So they can reinstate prescriptions etc
- Show unreconciled MESH messages on a new tab #5321
  - these are messages that we do not recognise (perhaps sent to us in error)
- Allow a document deletion to trigger an HL7 message #5334
  If an event or letter is soft deleted, a hosp might choose to send an HL7 message to the TIE (via Mirth) to signal that the document should be flagged as deleted in downstream document repositories. Enabled only at BLT currently

### Changed
- Switch to using slimselect for message recipient ids multi dropdown when sending a message #5268
- Disable 'edge' autocomplete on various inputs #5271
  - Prevent the Edge autocomplete popup from appearing when
    - searching for a patient in the top left search box
    - searching admin users
    - searching users
    - searching downloads
- Display daily queued and sent counts in UKRDC Activity widget #5273
- Move professional position under signature in user profile #5320
- HL7 MDM^T02 changes #5330
  - Add EVN segment
  - Correct order of segments in TXA.5 (backwards compatible)
  - Copy MSH processing_id into control_id for BLT (backwards compatible)
- Change Electronic CCs dropdown on letters form to use slimselect #5336
- Switch to using slim_select for dropdowns in
  - access procedures
  - admin/users
  - clinical profiles
  - All Patients list
  - pathology investigations filter
- Only show active users in drop downs #5363
  - Filters out banned and inactive users from all but the System->Users list.
- Merge renalware-forms-* into core #5387 (to test just check creating a Home Delivery Form pdf works)

### Fixed
- Messaging dropdown changes #5286
  - Fix javascript error during load of New Message form
  - Correct the order messaging recipients in dropdown
- Stop caching letter html table rows #5288
  - as this was also caching the the appearance/hiding of eg Edit button in the row without respecting the permissions of the current user
- Remove hidden users from dropdowns #5339
- Fix: Bug in report category dropdown, preventing duplicates #5374
- Fix: snippet actions not available on second page #5393

## 2.4.5.4
### Added
- Handle A04 ED admission messages #5242
- Do not send GP letter via MESH if patient.confidentiality = restricted #5241
- Handle ORM^O01 HL7 order/referral messages #5215
- Expire users inactive for a configured number of days #5211
  - Run the job every day at 2:00 AM. This address a bug where we expect an indication in the Admin Users -> Expired tab, and the user Expired? column, that user is expired by interrogating users.expired_at, but this column never gets populated. Users are still prevented from logging in as the devise_security#expired? method also checks last_activity_at.
- Add Requires BBV Slot (hep B+) to HD Slot request form #5190
  - Add a new attribute and column 'requires_bbv_slot' labelled 'Requires BBV Slot (hep B+)' to the HD Slot Request form. Selecting Yes or No is mandatory.
- add a daily job to set users.expired_at = now() where last activity was more than Renalware.config.users_expire_after days ago

### Changed
- Allow filtering reports by name #5248
- Make pathology_missing_urrs faster by using a temp table rather than a CTE #5243
- Switch date/time columns in event tables #5240
  - Switch the position in events tables of the Created On and Date/Time columns, as the default sort order is event.date_time and so having created_on as the first date columns is a bit confusing. Also it makes more sense for the created_at to be adjacent to the created_by column
- Allow devise user expiry to be configurable #5210
  - Defaults to 90 days. MSE have requested this be 45 days so have made configurable using an env var eg USERS_EXPIRE_AFTER=45
- Add activity warning next to recipient choosing for a message #5206
  - When adding a recipient to a message, augment the user's name in the dropdown with warning text if the user has never signed in or if if the user has not logged in for n days
- Filtering improvements #5186
  - Add auto-filtering to research studies
  - Add auto-filtering to research participants
  - Add auto-filtering to users table
### Fixed
- Fix pathology date issues #5254
  - Affects observations with BST timestamps between midnight and 1am
- Letter housekeeping, fix pagination #5250
  - fix pagination CSS formatting abd functionality on the Renal -> Letters lists
- Fix clinic visiting filtering #5222
  - On the Renal -> Clinic Visits and Patient -> Clinic Visits pages, the pagination was not working correctly if a filter was applied.
- UKRDC and letter fixes#5221
  - Allow nil hosp unit rendering UKRDC HD treatment XML
  - Default to sending letters over MESH (overridable with ENV var)
  - Refresh turboframe after printing a letter - reload turboframe.src rather than location.src to preserve filters.
    Refreshing will update (or remove if now filtered-out) the table row for the letter that was printed.
- Fix counts issue batch printing letters where there are pending GP Connect requests #5213

## 2.4.5.3
### Added
- Create a Remote Monitoring Registration custom event #5080
- Add support for HL7 SIU appointment messages #5091
- Add support for HL7 admissions #5090
- Display patient appointments on their clinic visits page #5097
- Allow for display of configured external links eg QlickSense) on Logon and dashboard… #5102
- Support loading Index of Multiple Deprivation database tables for use in analysis #5108
- Add a letter_snomed_document_types table #5117
  - A letter topic can be assigned a snomed_document_type, which will be used in GP Connect FHIR
  messages as Bundle.documentType. If the letter topic has no assigned snomed_document_type,
  the snomed_document_type with a boolean default_type=true (of which there can be only one due
  to unique index) will be used.
- Fetch and display Mirth queue stats (e.g. processed and errored counts) on a superadmin dashboard #5161
### Changed
- Update SQL fn that opts patients into renalreg based on egfr #5070
  - Use fn prototype variant convert_to_float(val, null) to return null where egfr cannot be
    coerced into a string eg '>60'. The current form convert_to_float(val) returns 0 for strings
- Offer vaccines filtered by ATC code when adding Vaccination event #5082
- Refresh prescribable_drugs materialised view after a drug edit #5098
- Include 'UNK' SDS code for all users in the FHIR Practitioner resource
- Add ods_code column to hospital_units #5137
- Capture email and up to two telephone numbers from HL7 PID #5152
- Import HL7 marital_status if available #5153
- Add versioning to clinic appointments #5154
- Allow a host app to override clinic resolution in outpatient HL7 message processing #5160
### Fixed
- Fix validation on OnlineReferenceLink#url #5086
  - Only validate the url starts with https:// or http:// and do not attempt to regex the whole url

## 2.4.5.2
### Added
### Changed
- Use a pathology code group to define hep_b_antibody_statuses OBX codes #5066
  - Rather than the previous implementation which was an ENV variable which is harder to change and less in keeping with our approach elsewhere. Code group name is 'hep_b_antibody_statuses'.
- On death modality deactivate HD profile if they have one #5065
  Rather than superseding with a new amended one with hospital unit and schedule nulled-out.
### Fixed

## 2.4.5.1
### Added
### Changed
- Supersede (deactivate old and create new) HD profile on death modality rather than directly update HD Profile #5036
  - Previously on death modality the patient's current hd_profile was updated to null-out hospital_unit and schedule_definition. This was the wrong approach and we should instead deactivate the current profile and create a new one with those nulled values. This way makes it easier to find what unit a patient was at before they died.
- Add configuration so non-admins can update PKB/RR settings #5039
- Mark letter and associated MESH transmission as failed on timeout #5033
  - If no bus or inf response received with the configured period, set transmission.status = failed and the letter.gp_sent_status = failed
- Retry on SaveRTFLetterToFileJob on Errno::EPIPE (broken pipe) errors #5004
  - BLT RTF rendering occasional error
- Allow a superadmin to delete events even if they have been sent to EPR as a PDF #4994
- Re-arrange Tx Wait List Registration form #4997
  - Move WL Status to the top (only appears in new record)
  - Move Organs section under it
- Add a from..to date for automatically including QR codes in letters #4974
  - If an OnlineReferenceLink (which becomes a QR code when inserted into a letter) has #include_in_letters_from and #include_in_letters_from dates that satisfy conditions, that QR code is automatically added to any new letters.
### Fixed
- Mesh ITK error eg 30003 was not setting letter.gp_send_status=failure #5043
- Mark letter and associated MESH transmission as failed on timeout #5033
- Use sending facility name in IDN07 rather than site code #5040
- Supersede rather than directly update HD Profile on death modality #5036
  - Previously on death modality the patient's current hd_profile was updated to null-out hospital_unit and schedule_definition. This was the wrong approach and we should instead deactivate the current profile and create a new one with those nulled values. This way makes it easier to find what unit a patient was at before they died.
- Fix HD Diary slot creation issue #5014
  - If scope was the first one in the dropdown eg 'Dialysing Monday Eve' then after choosing a patient and clicking 'Add to this and all future weeks', the patient was only added to the Weekly diary not the Master one. This was because some javascript in the diary slot form had not executed when the modal loaded.
- Fix bug filtering HD Slot requests by patient name #5007
- Fix error creating a new HD Session that has PGDs assigned #5003
  - Applies only when creating a new HD Session, adding one or more patient group directions (PGDs), and then clicking 'Create' or 'Save and Signoff'. Editing an existing session add adding PGDs at that point is not affected.

## 2.4.5
### Added
- Allow editing bookmarks #4940
- Display a Deleted letters tab for superadmin users #4909
- Add unique IDN07 Renal Registry id to patients #4927
  - autogenerated unique 10 char string
  - allow searching on this id
  - Display (along with prefixed hospital centre code) in patient Demographics under the Renalware Registry Preference section
- Send OptOut elements in UKRC XML if the patient has opted out of UKRR #4928
- Add system information to status page #4934
  - Ruby version
  - Rails version
  - Mirth version
  - Mirth java version
- Allow adding snippets to HD Session notes #4936
- Add external_reference column to research participations #4892
  - And allow this to be manually entered on creation/edit. This differs from external_id in that the latter is automatically generated (pseudo-anonymised for reverse lookup if required) and not editable.
### Changed
- Reorganisation of research, hospitals, and contacts (directory) folders, so these need some brief testing #4895
- Only an admin can update RReg and KB preferences #4925
- Update PD MDM Patients SQL view - Add POT and POT date, Add filters for hospital_centre, named nurse and named consultant #4912
- Capture malignancy site and diabetes type in comorbidities #4896
- Only an admin can update RReg and KB preferences #4925
- Store OBX.11 Observation Result Status #4939
  - Store the results status (eg P=Preliminary, F=Final) so that we can give precedence to Final results when displaying. Since a recent change to use OBR date for for the OBX values (rather than OBX observed_at), we need a better way of filtering out preliminary results which might say eg 'Sent to Lab'; a subsequent OBX with results_status of F=Final will arrive with the correct value, and we do not want the P result to obscure the F one.
- Upcase address.postcode on save #4964
- Conditionally validate the presence of HD Session PGDs if HD_SESSION_REQUIRE_PATIENT_GROUP_DIRECTIONS=true #4966
- Update demographics on HL7 ADT^A05 message #4965
- Improve styling of flash messages (eg 'updated successfully') #4946
### Fixed
- Fixed but after updating an event, where the user had gone straight to the edit page rather than clicking on an 'Edit' link to get there #4911
- Fix pagination in the snippets dialog which was causing the Insert Snippet dialog not to load #4900
- Handle non-Windows-1252 characters in PDF address cover sheet #4923
- Fix error searching all HD patients when adding to diary slot #4930
- Remove custom logic in Swab and Vaccination policies - use the Event Type admin UI to set policies #4963

## 2.4.4
### Added
- Continue building out support for rendering PDF letter using prawn (no change to current wkhtmltopdf rendering so nothing to test yet) #4682
- Add a simple status page at /status #4838

### Changed
- Disable Edge autocomplete on prescription inputs #4821
- Add optional weighting to medication_routes #4811
  Change via database to make routes with a larger value float to the top of the list.
- Use type-ahead ajax fuzzy lookup when searching for drugs in prescriptions form #4806 #4810
- Allow superadmin to soft-delete approved letters #4831
- Add configuration to allow letters to be omitted from UKRDC XML #4853
- Display readonly research study settings on Study Summary page #4843
- Update to Ruby 3.3.3
### Fixed
- Fix modality filter and modality sorting on RR Preflight Checks page #4833
- Fix 'access token expired' error syncing dmd with ontology #4813
- Change research_participations.external_id column from int to text to allow for alphanumeric references #4844

## 2.4.3
### Added
- Add immunology risk and induction agent to Tx Recipient operation #4802
- Add location, access state to HD Slot Requests, and in table view add location filter, display location, access state and creating user #4791
- Allow a permitted user to renew selected HD Prescriptions for eg 6 months #4787
- Add an 'allocated' urgency option to HD Slot Requests #4829
### Changed
- Include a reason in Historical Path ReplayRequest log when patient was created via AKI #4793
- Do not overwrite HD prescription termination date (if entered) on creation #4780
- Set future prescription termination date to be today when force terminating eg when renewing or clicking Terminate #4825
- Do not validate prescription termination dates when renewing/revising a prescription #4818
  this allows prescription_termination.terminated_on to be < prescriptions.prescribed_on,
  when terminating future prescriptions by setting termination_on = today
- Paginate patient clinic visits #4801
### Fixed
- Omit country code from UKRDC addresses if no country specified #4789
- Do not validate prescriptions when terminating on death modality #4828

## 2.4.2
### Added
- Add Medically fit for discharge checkbox on HD slot requests #4670
- Allow a admin to soft-delete an HD prescription administration #4668, #4738
- Capture when a patients requests their UKRDC data be anonymised #4662
- Alternative experimental chart support for reports using the chart_raw column on view_metadata #4618
- Add a demo scheduled function to illustrate updating patient.send_to_renal_reg #4705
- Display patient group directions on read-only HD Session view #4742
- Add Tx 'Kidney and other' option to recipient operation and wait list registration #4739
- Replay historical pathology messages when new patient added #4411
### Changed
- Add titles eg '2. Well' to Clinical Frailty Scores events #4697
- Display runtime errors to superadmins #4687
- Display L or D against prescription dates in HD protocol #4676
- Load report data asynchronously after the page has loaded #4671
- Ensure modality history is editable by Admins and Superadmins #4635
- Update Rails to 7.1 #4695
- Upgrade to Ruby 3.3.0 #4708
- Icon housekeeping #4709
- Use OBR.7, falling back to OBR.6 if missing, instead of OBX.14 when storing pathology_observation.obseved_at #4752
- Performance and usability improvements to the Renal->Events and Patient->Events pages #4758
- Switch from kaminari to pagy pagination library (already used in many places) in the following locations
  - admin/users
  - clinical/dry_weights
  - admin/drugs
  - hd/unmet preferences
  - Patient -> letters
  - admin/drug_types
  - Patients -> Patients list
  - Renal -> RR Preflight checks
- Reporting module refactor - please test
### Fixed
- Allow sign in page to scroll correctly #4698
- Fix bug displaying unnecessary Overlapping Modality message #4704
- Prevent bots crawling documentation #4710
- Fix bug loading reports 'Configure columns' modal on MDMs/reports #4716

## 2.4.1

### Added
- Add Patient Group Direction options to HD Session, with admin UI to configure #4478
- Add a new 'HD Prescriber' role and stat prescriptions #4464
- Allow customising the landing page for patient links in reports #4453
- Allow editing and deleting modalities #4436
- Set a future termination for HD prescriptions #4559: When creating a prescription where administer_on_hd=true then assign a prescription_termination with a date 6.months in the future. This value is configurable via Renalware.config.auto_terminate_hd_prescriptions_after_period and to disable the new behaviour set this to nil. When creating a prescription where administer_on_hd=true and stat=true then set a future termination date of 14 days
- Add DSA 'Donor-specific antibody' to Tx Investigation dropdown #4566
- Add a report to identify patients sharing the same NHS number #4579
- Support simple line graphs in reports #4605

### Changed
- Don't allow administration of future HD prescriptions #4562
- Include unit_dose_form_size_uom_code dm+d UOM #4556
- Only search the last 1m rows when calculating urrs #4527 to speed the query up.
- Store and display how many times a report is viewed #4499
- Identify dmd drugs in prescriptions view #4476 using a key
- ESI/PE prescription display changes #4472 - Now that only there is only one list of meds on this page (combining current and historical), change the title 'Current' to 'Antibiotics/Routes'
- Break out HD and Tx opt-level menus #4483
- Mark a message as read after replying #4467
- Changes to the way modalities are added #4438 - Stop capturing modality change reasons, enforce change type, capture source and dest hospitals if change type require them
- Disable inactivation of non-dmd drugs during nightly dm+d syncing #4501
- Include the current access profile/plan as first row in respective history tables #4541
- Add unique index to drug frequencies #4548
- Allow Access Plan type dropdown to be searchable #4552
- Display future HD prescriptions up to 10 days ahead on HD protocol #4567
- Don't validate needle_size when signing off HD Session #4577
- Omit null vales when charting pathology #4588
- Soft delete patient worries #4594
- Support per-message type (ADT, ORU etc) patient location strategies #4612
- Add 'dynamic' patient locator strategy for MSE ADT HL7 messages #4614
- Terminate given HD stat prescriptions immediately if they have a future termination date #4631

### Fixed
- Use prescription.drug_name when displaying #4539 to ensure trade family name is included
- Fix PKB typo #4498
- Omit inactive drugs from admin drugs page #4491
- Fix error adding PD bag type if glucose-strength omitted #4432
- Fix occasional race condition creating patient from eg AKI HL7 msg #4502
- Reinstate drug colour-code key on prescriptions page #4558
- Remove blank NHS numbers from duplicate_nhs_numbers view #4580
- Fix 'undefined local variable or method operation' in RecipientOperationsController#show #4582
- Fix display of PD regime delivery frequency #4585
- Fix problem sorting (was sorting by problem notes date not problem date) #4589
- Fix prescription colour highlighting on clinical summary #4590
- Prevent QR code table rows from spanning page breaks #4591
- Allow prescriptions with future termination dates to be 'terminated' #4592
- HD Slot request fixes - validate present of notes - any user can see the historical tab - use a modal for the edit form - remove references to specific_requirements column  #4598
- Use correct (dm+d) dose unit on homecare delivery forms #4609
- Fix problem/prescriptions overlay on clinic visits form, preventing clicking 'Create' when patient has a long list of problems #4613

## 2.4.0

### Added
- Highlight non-contiguous entries in the modality listing #4437
- Add 'hospital ward' option to hospital unit types #4452
- Log near-match occurrences in HL7 ingestion #4413 Where we match on number but not DOB, log to a table and include the patient id and feed message id. Display these log entries in the backend so an admin can view and resolve manually if necessary.
- Identify home HD Sessions in HD Sessions table with a home icon #4423
- Extract ORC filler_order_number from HL7 when persisting to feed_messages (ready for historical pathology replay) #4427
- Extract ORC order status from HL7 when persisting to feed_messages (ready for historical pathology replay) #4425
- Highlight non-contiguous entries in the modality listing #4437
- Add drop-down urine glucose to clinic visits and then include in the letters #4386
- Add clinic visit location in order to support virtual clinics #4391
- Add drug type and dm+d filters to drugs list #4409
- Add home_machine_identifier to HD Profile for Baxter HDCloud support #4405
- Add 'Relaxation of restrictions' option to dietetic CV interventions #4382
- Add hospital centre filter to the live donor list #4342
- Support html and text mail in MS Graph API #4383
- Support sending email via MS Graph API from NHSMail mailbox #4353
- Schedule materialised view refreshing #4349
- Add support for using good_job HL7 processing via a feed_raw_hl7_messages queue table #4267
- Allow choosing a code group when viewing historical pathology #4336
- IgAN prediction tool #4335
- Add regex columns to RaDaR diagnoses table #4341
- Store RaDaR cohorts and diagnoses #4338
- Add QR code links to online articles to letters #4103
- Add VND Risk Assessments #4272
- Add notes and admin notes to toggled dietetic row #4293
- Create a Transplant Review event similar to Medication Review. Will be invokeable from a new Tx Dashboard screen #4300
- Add an 'API log' page in the admin section to make it easier to debug issues #4324
- Add a job type that can execute a SQL function, eg via cron #4328
- Add 'View All' button to API logs component on superadmin dashboard #4327
- Switch to using dm+d drugs in prescriptions. The drug list is updated automatically #4247
- Introduce a Hospitals::Department model to capture the telephone/address of an administrative department #4250
- Add RR19 malignancy sites to database #4219
- Add Visit Type filters at the top of Dietetic MDM list #4210
- Add RR outcome code to Death::Location in preperation for RR5 dataset #4203
### Changed
- Make Dietetic MDM Patients a materialised view #4369
- Persist HL7 msg patient identification to feed_messages.local_patient_id* #4357
- Save id of source feed_message on pathology_observation_request #4365
- Add N/A to the drop down list for sga_assessment in dietetic clinic #4343
- Display spinner when Ajax-loading report table #4374
- Ensure all emails are sent using ActiveJob #4347
- Restrict HD Session access type choice by hd_vascular=true #4340
- Prescriptions column heading changes - add a new column 'Stop on' after 'Prescribed on' - rename 'Terminated on' to 'Stopped on' #4260
- Add missing dietetic CV data items to the toggled table cell #4258
- Add rounded borders and add more spacing to form inputs #4273
- Add new columns to drug_frequencies to allow dose calculation #4259
- Trim leading/trailing space around items in HL7 PID segment #4296
- Add sortable columns to reports page #4269
- New patient locator strategy using NHS or any hosp number and ignoring DOB #4288
- Ensure soft-deleted event types remain visible where previously used #4311
- Rename Mean URR to to URR in HD letter template and add URR date #4312
- Add new columns to feed_messages (local_patient_id etc) to support (later) migration of patient_identifiers to local_patient_id* columns #4310
- Sort Dietetic MDMs by clinic visit date descending #4315
- Move to Rails 7 and Ruby 3.2
- Convert UpdateRollingPatientStatisticsJob to an Active Job #4256
- Date picker and time picker enhancements #4254
- Move drug frequencies into a database table #4246
- Login page styling improvements
- Change references to RPV to PKB in UI #4237
- Migrate Audits to Reports #4188
- Move mini clinical profile above alerts on patient layout #4165
- HD Session form PDF changes - Add Solution flow from HD profile next to Blood Flow and indicate if Worry #4164
- Refresh browser page automatically in development #4243
### Fixed
- Fix missing QR codes in PDF letter #4381
- Fix dm+d millilitre mapping (ml/l is now ml) #4422
- Fix column highlighting in pathology tables #4428 A bug had emerged where, if the 'view' onto the pathology changed, eg from 'default' to 'HD', the column would not highlight when hovered-over (a feature to help the user identify the relevant column header in the table). Also fix missing popup on blue triangle comments in the recent pathology view.
- Fix error adding PD bag type if glucose-strength omitted #4432
- Correct the default date in the filter in Appointments list #4390
- Address dm+d mapping issues #4408
- Fix default_patient_link usage in dynamic reports #4350
- Ensure termination date is editable when editing a prescription #4276
- Fixed bug creating an event when changing dropdown from eg Clinical Frailty Score to Medication Review (missing partial) #4303
- Fixed error creating letter from dietetic visit #4292
- Use the ClinicVisitPolicy for Dietetic clinic visits so they are no longer editbale after 7 days #4261
- Include a name when JIT-creating Kt/V observation description #4220
- Reply to a message should reply to all recipients in original message #4208
- Fix error viewing own letters #4193
- Trim whitespace from local_patient numbers when saving new patient #4169
- Error when deleting a clinic visit created from an appointment #4162
- Fix patient_scope syntax to correct Worryboard#show error #4160
- Reinstate pathology table top scroll bar #4183

```
