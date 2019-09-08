# Change Log

All notable changes to this project will be documented in
this [changelog](http://keepachangelog.com/en/0.3.0/).
This project adheres to Semantic Versioning.

## Unreleased
### Added
### Changed
### Fixed

## 2.0.105
08-09-2019
### Added
### Changed
- UKRDC changes #2856
### Fixed

## 2.0.104
06-09-2019
### Added
### Changed
- UKRDC changes #2852
### Fixed

## 2.0.103
06-09-2019
### Added
### Changed
- UKRDC changes #2851
### Fixed

## 2.0.102
03-09-2019
### Added
### Changed
- UKRDC changes #2838
### Fixed

## 2.0.101
28-08-2019
### Added
### Changed
### Fixed
- UKRDC Missing Dialysis Bloods/Weights/Observations #2775
- Set EnteringOrganization to main site code eg RJZ on Medication elements #2830
- No POST observations reported in XML #2690
- Populate ukrdc prescribing location #2766
- Populate EnteringOrganization in Medication in UKRDC XML #2777

## 2.0.100
27-08-2019
### Added
- Add housekeeping rake task #2763
### Changed
### Fixed

## 2.0.99
23-08-2019
### Added
- Add option on signup for user to request write access
### Changed
### Fixed

## 2.0.98
23-08-2019
### Added
- Add dna and outcome notes columns to appointments #2813
- Add consultants table #2782
- Add legacy_code column to pathology_observation_descriptions #2784
### Changed
- Create new PD regime - start date should be todays date #2791
### Fixed

## 2.0.97
### Added
- Add a configurable ukrdc_pathology_start_date #2781
### Changed
### Fixed

## 2.0.96
### Added
### Changed
### Fixed
- Fix slow UKRDC path query

## 2.0.95
23-07-2019
### Added
### Changed
- UKRDC LabOrder changes #2762
- Change patient ukrdc_external_id type from uuid to string #2760
### Fixed

## 2.0.94
19-07-2019
### Added
### Changed
### Fixed
Fix extraction of rr41 from session#access_type_abbreviation #2756

## 2.0.93
18-07-2019
### Added
### Changed
- UKRDC treatment changes
- GPG encryption changes to avoid use of random_seed file
### Fixed

## 2.0.92
11-07-2019
### Added
### Changed
- UKRDC treatment changes
### Fixed

## 2.0.91
11-07-2019
### Added
### Changed
### Fixed
- Fix UKRDC query to select medications with a numeric dose_amount

## 2.0.90
10-07-2019
### Added
### Changed
- Improve memory handling in UKRDC XML export #2742
- Omit prescriptions in with a non numeric dose amount - UKRDC XML #2741
### Fixed
- UKRDC Treatment refinements #2743

## 2.0.89
### Added
- Output QBL05 for HD Treatments #2736
- UKRDC export - add 'force_send' option #2735
### Changed
### Fixed


## 2.0.88
### Added
### Changed
### Fixed
- Filter out deleted GPs when adding a GP to a patient
- Move database tables to the corect schema.

## 2.0.87
### Added
### Changed
### Fixed
- Fix ODS/zip file permissions access on Linux

## 2.0.86
### Added
### Changed
### Fixed
- Letters const resolution bug in UKRDC export #2722
- ODS CSV import PG path error - use /tmp folder #2724

## 2.0.85
### Added
### Changed
- Add Tx Operations to UKRDC XML #2719
### Fixed
- Omit documents in UKRDC XML for non-RPV patients #2720

## 2.0.84
### Added
- Add Rejection Episodes in Recipient Transplant Followup #2700
### Changed
- Include patients with send_to_renalreg=true in UKRDC XML export #2717
### Fixed

## 2.0.83
### Added
- Transplant Followup - adding graft function onset #2702
- Transplant Followup - record date of last Dialysis post transplant #2703
- Transplant Followup - record date of last Dialysis post transplant #2703
- Haemodialysis session - display Resp Rate in the columns #2711
### Changed
- UKRDC access changes in XML for HD Sessions #2713
### Fixed

## 2.0.82
### Added
### Changed
### Fixed
- Omit UKRDC Treatment ToTime if missing #2708

## 2.0.81
### Added
### Changed
### Fixed
- UKRDC Treatment changes as per schema #2708
- Move position of DeathCause in UKRDC XML #2706

## 2.0.80
### Added
- Generate UKRDC treatments #2685
### Changed
- Send all medications to UKRDC, not just current ones #2699
### Fixed

## 2.0.79
### Added
- Send UKRDC medication dose uom and quantity #2688
- Add a scroll bar to the top of Historical Pathology #2694
- Send comorbidity diagnoses in UKRDC XML #2691
- Add recent consults to bottom of clinical summary #2669
- Add Pre/Post Respiratory Rate to HD Session form #2642
- Enhancements to Virology page #2540
  - add Hepatitis B Core Antibody positive
  - display the latest HepB Surface Antibody titre on virology page
- Sync practice additions/deletions/changes via the NHS API #2696
### Changed
- Update EDTA textual descriptions to match UKRDC #2689
- Make clinic visit form remember the last chosen options #2651
### Fixed

## 2.0.78
### Added
- Add recent clinic visits to all MDMs #2652
- Create AVF/AVG Assessment Tool #2632
- Hide non-printable elements on MDM pages when printing #2663
- Add date of graft nephrectomy to Tx Recipient Followup #2682
- Support multiple configurable subsets of path results for use eg. in MDMs #2664
- Add a ukrdc_modality_codes table #2678
### Changed
- In HD MDM prescriptions section remove the type column #2665
- Make login banner title configurable #2673
### Fixed
- Preserve filters on Consults list when marking one as Done #2671

## 2.0.77
### Added
### Changed
- MR VICTOR changes #2641
- Add dietry protein intake (DPI) to PET Adequacy #2618
- Admin notes not visible after letter approved #1366
### Fixed

## 2.0.76
### Added
### Changed
### Fixed
- UKRDC XML fixes #2658

## 2.0.75
### Added
### Changed
### Fixed
- Fix duplidate LabOrders in UKRDC XML #2631

## 2.0.74
### Added
### Changed
### Fixed
- avoid duplidate LabOrders in UKRDC XML #2630

## 2.0.72
### Added
- HD Session Form - add CRP to Pathology section #2484
### Changed
- Split routes.rb into separate files for each module #2565
- New/edit patient form improvements #2609
- Add updated_at and created_at cols to obx and obr tables #2608
- Create missing OBR and OBX codes dynamically #2607
- Update ruby version used in dev and testing to 2.6.2 #2614
### Fixed
- Toggling clinic visits is ugly when there are html notes #2569

## 2.0.72
### Added
- Add versioning to AKI alerts #2597
- Print home delivery drugs #2315
### Changed
### Fixed
- UKRDC validation fixes #2594

## 2.0.71
### Added
### Changed
### Fixed
- UKRDC XML Change procedure type to Haemodialysis #2583
- UKRDC XML Fix error when there is a missing cause of death #2583

## 2.0.70
### Added
- Support saving an Event to PDF for example to EPR #2573 #2489
### Changed
- Autofocus the first/relevant input on forms #2568
- Prefix top menu urls with renalware.* to allow link to work while rendering views inside another engine #2566
### Fixed
- Remove empty parentheses next to patient name if they have no NHS number #2568
- Prevent an entry in system_visits on session_timed_out #2547
- Remove n+1 queries in UKRDC XML generation #2541

## 2.0.69
### Added
### Changed
- Housekeeping #2529
### Fixed

## 2.0.68
### Added
- Add ActiveStorage in preparation for adding file attachments to patients #2514
### Changed
- Changes to way Clinical Studies are displayed, in order to prepare for HEROIC #2522
- Convert Study Participants add/edit modal dialog into a full page #2516
- Move address on letter cover sheets down 10mm for Z-folding #2525
### Fixed

## 2.0.67
### Added
### Changed
- Add an HD patient's named nurse as a default electronic CC on new letters #2483
- HD MDM - displaying latest Dry Weight #2459
- On MDM screens add a link, opening in a new tab, to the patient's Prescriptions screen to make
  updating prescriptions easier #2498
- UKRDC changes #2495
  - Add date to LabOrder SpecimenCollectedTime
  - Remove unused elements
  - Remove ContactDetails
- On HD Session form add field for MR VICTOR status (an inspection tool for HD catheter site) #2494
- Update Rails to 5.2.2 #2496
- Housekeeping #2500 #2502 #2499 #2492 #2491 #2488 #2487 #2503
- Sort and paginate user's bookmarks #2506
- Rename 'ESRF / Co-morbidities' menu item to 'Renal Profile' #2505
- Ensure GP practice name appears in practice address in letters #2384
- Add CRP to Recent Pathology in HD Protocol section #2484

### Fixed

## 2.0.66
### Fixed
- Database migration enhancements to support BLT

## 2.0.65
### Fixed
- Extend information stored when logging imported HD Sessions

## 2.0.64
### Fixed
- De-duplicate ccs when archiving a letter.

## 2.0.63
### Changed
- Allow 2 decimal places in weights, to support dialyser data import

## 2.0.62
### Changed
- Letter enhancements

## 2.0.61
### Fixed
- Fixed migration error

## 2.0.60
### Changes
- Letter improvements and additional tests

## 2.0.59
### Changes
- Add a view to aid reporting of incoming HD Sessions

## 2.0.58
### Changes
- Look for 'reporting_daily_xxx' views in any namespace #2473
- Keep development logs small #2472
- Change copyright to 2018 #2468

## 2.0.57
### Changes
- UKRDC XML enhancements

## 2.0.56
### Changes
- UKRDC XML enhancements

## 2.0.55
### Changes
- UKRDC XML enhancements #2463 #2460

## 2.0.55
### Changes
- UKRDC XML filename format changes #2460

## 2.0.54
### Changes
- Changes to the way UKRDC XML files are saved #2456
- Most HD Session HDF fields can now be blank, to allow for Diaverum which does not supply them #2452
- KTV values can not be in the range 0.05 to 3.5 #2452
### Fixed
- In problem lists display the name of the last user to make a change #2452

## 2.0.53
### Fixed
- Report errors in UKRDC rake tasks #2451
- UKRDC XML undefined method 'renal_registry_code' for nil:NilClass #2388

## 2.0.52
08-10-2018

### Added
- Use jemalloc in Heroku review apps to reduce memory usage #2433
- Add Transplant Candidates tab to Low Clearance MDM patients list #1774

### Changed
- Use jemalloc in Heroku review apps to reduce memory usage #2433
- Improvements to Daily Summary Email #2424
- UKRDC XML changes #2445

### Fixed
- Add Practice name to GP addresses on letters #2384
- Fix issue where if > 1 transplant registration status added on the same day,
  the first stays active #2162
- Fix missing patients when sorting Consults by modality #2432
- Security fixes #2420

## 2.0.51
08-10-2018

### Fixed
- Tweaked position of the address in the envelope window when targeting the envelope stuffer

## 2.0.50
08-10-2018

### Fixed
- Remove GP from envelope-stuffer print output if they have already received the letter by email

## 2.0.49
08-10-2018

No change

## 2.0.48
04-10-2018

### Changed
- removed a migration with an index that was taking a long time to build

## 2.0.47
04-10-2018

### Added
- Support generating printable output compatible with an envelope stuffer #2382
- Sort and filter Renal Reg pre-flight checks by HD Site #2101
- Upgrade rails to 5.2.1 #2247
- Toggle HD session notes in HD session listing #2401
- Disallow adding a patient with no hospital or NHS no #2217
- Filter and tab design improvements #2400
- Toggle clinic visit notes on Clinic Visits list #2395
- Sorting on Tx Status in Low Clearance MDM patients list #2389
- Prevent unapproved users from being new Message or eCC recipients #2403
- Highlight banner patient number when clicked on #2165

### Changed
- Handle deleting a ward that is in use #2367

### Fixed
- Daily summary email not sending #2392
- Daily summary reports not always created in the renalware namespace
- Deceased patients continue to age #2394

## 2.0.46
21-09-2018

### Changed
- Only pass the FeedMessage when broadcasting message_processed event #2391

## 2.0.45
21-09-2018

### Added
- Support async Wisper subscribers #2381
- Support sending a daily summary email #2373
### Changed
- Encrypt UKRDC XML files automatically before sending #2386
- Add 'Patient Refused' vaccination type
- Prepare for Rails 5.2 #2372 #2376 #2375 #2377
### Fixed
- Should include both approved and completed letters in UKRDC export #2387
- HD audit view does not refresh after monthly report generation #2378

## 2.0.44
29-08-2018

### Added
### Changed
- Improve delayed job performance #2370
### Fixed
- Entering an integer into the Patient Search field causes an error #2364
- PD Assessment date validation #2366
- Transmission log fix #2363

## 2.0.43
17-08-2018

### Added
### Changed
- Improved AKI Alerts ward display

### Fixed

## 2.0.42
16-08-2018

### Added
- Support for HD providers like Diaverum and Fresenius #2307
- Allow listing Aki Alerts by date #2248
- Add % fistula or graft to HD Overall audit #2357
### Changed
### Fixed
- Patient search sort order order wrong when results contain a mix upper and lower case family names #2200
- PatientSearch is intercepting ransack searches if params[:q] present #2316
- Add StudyParticipantsController#show action #2358
- Fix KCH letter create error #2356

## 2.0.41
14-08-2018

### Added
- Manually create a clinic appointment #2343

### Changed
### Fixed

## 2.0.40
08-08-2018

### Added
- On HD Session form display users who signed-on and off the session #2342
- Add HTLV to Virology Profile #2341
- Add Supportive Care filter to Low Clearance MDM patients listing #2332
- Add HD Schedule filter (eg MWF, MWF AM, etc) to HD MDM patients listing #2074
- Add MDM sorting by access plan type, plan date, current access and transplant registration status #2337
- Ability to see Problem list and Medications whilst composing a letter #2090
- LCC MDM screen virology additions #2303

### Changed
### Fixed
- Correct the dashboard default sorting #2263

## 2.0.39
16-07-2018

### Fixed
### Added
- Ability to hide a modality so it cannot be added to a patient #2318
- Ability to view all bookmarks #2324
- Added events to bottom of all MDMs #2323
- Add Additional Info section to a PD MDM #2322
### Changed

## 2.0.38
10-07-2018

### Fixed
### Added
- Add Additional Information section to HD MDM
- Add ESRF date and modality filters to Renal Reg pre-flight checks
### Changed
- Strip white space around JSONB documents

## 2.0.37
28-06-2018

### Fixed
- letter sort order

## 2.0.36
28-06-2018

### Added
- Added letterhead filter on Renal Letters page
### Changed
- Strip whitespace around numerics when saving jsonb documents
- Add PerRectum medication route to demo data
### Fixed
- Prescriptions now sort by drug name then prescription date descending
- Letters now sort by the date they were moved into their correct state (e.g. Approved)
- Fix UKRDC XML issues
- Fix patient demographics layout where telephone and email labels not aligning

## 2.0.35
21-06-2018

### Added
### Changed
### Fixed
- UKRDC export updates patient.sent_to_ukrdc_at date correctly

## 2.0.34
21-06-2018

### Added
### Changed
### Fixed
- Ordering of letters in lists

## 2.0.33
19-06-2018

### Added
### Changed
- When displaying tables of letters, make the Date column the date+time when the letter was edited
- When displaying tables of letters, display most recently updated letters at the top
  except on the user's dashboard where the order is reversed
- Add membrane_surface_area and membrane_surface_area_coefficient_k0a columns to HD Dialysers
- Add bicarbonate_content etc columns to HD Dialysates
### Fixed
- Do not output patient language in UKRDC XML if it is "Unknown"

## 2.0.32
14-06-2018

### Added
### Changed
- Updated Low Clearance profile dialysis plan dropdown options
### Fixed

## 2.0.31
07-06-2018

### Fixed
- Fixed caching bug where research study participation alerts were not invalidating
  when the study's application_url or name was changed.

## 2.0.30
07-06-2018

### Fixed
- Fixed an issue preventing migration of SQL functions in host app

## 2.0.29
06-06-2018

### Added
### Changed
- Support linking to external clinical study applications, including passing a new
  pseudo-anonymised participant id
### Fixed
- HD Sessions stamped with the wrong dry_weight (first not latest)

## 2.0.28
31-05-2018

### Added
### Changed
- UKRDC XML changes
### Fixed
- Disallow duplicate OBX and OBR codes

## 2.0.27
21-05-2018

### Added
### Changed
### Fixed
- Fixed bug in BP validation where systolic or diastolic contains spaces #2260
- Fixed bug loading a form where an underlying jsonb date is invalid #2259

## 2.0.26
21-05-2018

### Added
- Ward management
- `patient_current modalities` view to make querying patients by modality easier
### Changed
- Raise custom error if OBX or OBR code not found, so we can see the missing code
### Fixed
- Bug searching consults using e.g. `rabbit r`
- Fix letter layout when excluding pathology as instructed by the letterhead in use
- Fix blank screen (InvalidAuthicityToken error) when logging in after a after a
  javascript session timeout

## 2.0.25
08-05-2018

### Added
### Changed
- Display ward name and code in AKI alerts
- Add hotlist tab to AKI Alerts
- Prevent duplicate HL7 messages being imported #2244
- Use headless chrome for testing #2243
- Improve AKI Alert printing #2241
- Improve Consult printing #2240
- Display space for user putting on/taking off on HD Protocol #2145
- Filter consults by RRT #2242
- Add notes to Transplant Waitlist Registration #1854

### Fixed

## 2.0.24
08-05-2018

### Added
### Changed
### Fixed
- Allow a GP to be added to a patient with incomplete demographics.
- Topup API error

## 2.0.23
03-05-2018
### Added
### Changed
- Its now possible to generate HD monthly audits for specific year and month
### Fixed
- When a patient dies, terminate only current prescriptions and do not change the termination
  dates of previously terminated ones

## 2.0.22
02-05-2018

### Added
- Add an warning to the New Patient form to ask the user to check the patient does not already exist
- Add HIV HepB HepC to Virology Profile
### Changed
- Local patient ids (hospital numbers) should be unique (currently validating at the application but
  not the db level).
### Fixed
- Supply defaults of UNKNOWN and today's date if HL7 requestor name or date are blank
- Occasional incorrect format of letter rows in tables
- Fix unresolved MonthPeriod constant generating HD Monthly audits

## 2.0.20
27-04-2018

### Added
### Changed
- HD Overall Audit enhancements
- AKI Audit UI tweaks
- Admission Consults UI tweaks
### Fixed
- UKRDC rake task accepts an optional list of patient ids correctly

## 2.0.19
26-04-2018

### Added
### Changed
- Add check in PracticeMailer that the letter is completed or approved
- No longer rounds new Event date times to the nearest hour
### Fixed
- Removed unnecessary check that a letter has a practice in PracticeMailer which was causing
  letters for a patient without a practice to fail when sent to QEH admin email.
- When sending letters using PracticeMailer, cast to a super class otherwise if the letter state
  (and STI class) moves on the letter will not be found by the background worker.

## 2.0.18
24-04-2018

### Added
- Allow searching users by email address
### Changed
- Allow a host app to supply an exception notifier instance via Renalware::Engine#exception_notifier
  which will be used to log errors in non-ActiveJob and non-ApplicationMailer delayed jobs.
### Fixed
- Remove unused :recipient argument in PracticeMailer which was causing an error at KCH.
- Fix `unresolved NullObject` error in routes by supplying an instance of the new NullUser class.

## 2.0.17
23-04-2018

### Added
- UI for managing feedback
### Changed
- Improve consults seeding in demo
- Update Rails to version 5.1.6
- Added sorting by modality in Wait List
- Changed wording in HD Session for to Put On By and Taken Off By
### Fixed
- Prevent deletion of completed letters
- Correct algorithm for calculating mean_ufr in HD audit
- Fixed CAPD glucose calculations when a bag's type changes

## 2.0.16
18-04-2018

### Added
### Changed
- Display HD Site in TX Wait List
- Display patient name to user's letters list
- Display HD Site in patient banner
- Removed unused code ad routes
### Fixed
- Fixed #2160 Unread eCCs now only visible (and be marked as read) for approved and completed letters
- Fixed #2168 String comparison with zero error creating hd_statistics row

## 2.0.15
06-04-2018

### Added
### Changed
- Make the HD Session Save button grey
- Improve AKIAlert demo seeding
### Fixed
- Use created_at for the AKIAlert today scope

## 2.0.14
06-04-2018

### Added
- AKI Alerts Today and All tabs on index view
- Index view to patents API
- Rake task to allow a developer to sign off stale sessions

### Changed
- Removed CRE value and date columns from AKI Alerts table

### Fixed

## 2.0.13
05-04-2018

### Added
### Changed
- Add validation to HD Session to prevent non-numeric data being entered which affects auditing
- Change layout of recently changed medications in letters and medications print-out
### Fixed
- display any telephone or email associated wth a patients address in addition t
  o the those attached to the patient

## 2.0.12
29-03-2018

### Added
- Rake task to refresh all materialized views
### Changed
- In letters, patient and contact address parts have their own line rather than having
  town county postcode on the last line
- Make patient_id required in Transplant Recipient Operations table
### Fixed
- Printing consults list #2081
- 'myocardial_infarction typo' in transplant recipient operations
- Default sort in Internal Messages
- Corrected default sort order of prescriptions in MDMs
- Fixed an error viewing demographics when patient is deceased but has no first cause
- Corrected display of recent pathology results in letters

## 2.0.11
23-03-2018

### Added
- Added latest dry weight to HD Protocol
### Changed
### Fixed
- Error approving a letter with an address with no postcode

## 2.0.10
22-03-2018

### Added
- Display VIA EMAIL to xxx is recipient/cc is a GP and patient's practice has an email address

## 2.0.9
22-03-2018

### Added
### Changed
### Fixed
- Female default name prefix changed from Mme to Ms
- Use patient title in patient summary in letters
- Fixed default sort order in user's letters list
- Fixed sorting by eg HGB result in MDM patients lists
- Fixed HD Audit delayed job error failing with non-numeric path results
- Remove misplaced Dear in front of GP addresses in letters
- Increase padding below CC: heading in letters

## 2.0.8
19-03-2018

### Added
- Added 'Tx in Past Year' filter to Tx MDM listing
- Display Practice telephone and email in patient demographics
### Changed
- Added PCR and ACR to Current Investigations
### Fixed
- Remove 'Barts and London' title from printed Medications list
- Sorting by OBX result in MDM lists where there are non-numeric results
- Added 'Yours sincerely' to letters
- Allow soft delete of consults with no consult_type in migrated data
- Fixed letter error when is GP but Practice (patient main recipient radio not selected by default)

## 2.0.7
16-03-2018

### Added

### Changed
- Increase spacing between CCs on letters
- Consults: better filtering and searching
- Enlarge Problems text entry box

### Fixed
- Footer on error pages now sticky
- Alert partial missing error
- Snippets modal and snippets management page are now scrollable and html content doesn't wrap
- HD MDM change_in errors when post measurement is a string that cannot be coerced into a number
- Correct the set of practices imported from TRUD

## 2.0.6
14-03-2018
### Added
### Changed
### Fixed
- Correct salutation on newly added letter contact
- Remove use of address.name which was causing blank addresses in letters
- Import practices with organisation role RO177 as well as RO76
- Compact the New Contact dialog so it fits on the screen

## 2.0.5
13-03-2018

### Added
### Changed
### Fixed
- Error displaying change_in values in HD Sessions table when measurement are not numeric

## 2.0.4
13-03-2018

### Added
### Changed
- Removed unnecessary validations on Transplant Recipient Operation
- Removed unnecessary validations on HD (Closed) Session

### Fixed
- Admission Consults uses ended_on date not deleted_at for determining active status

## 2.0.3
13-03-2018

### Added
- Filters on consults
- Optional signup_help partial

### Changed
### Fixed

## 2.0.2
12-03-2018

### Added
### Changed
### Fixed
- Always use practice address when sending to GP
- Resolve missing patient CC on letters

## 2.0.1
11-03-2018

### Added
### Changed
- Make OBR requestor_order_number nil if blank
- Ensure uniqueness of OBR requestor_order_number
### Fixed

## 2.0.0
09-03-2018

### Added
- Display an alert if the user is in a clinical study
- Track page views and logins

### Changed
- Support overriding the login warning messages
- Make OBR requestor_order_number unique
- Filter and search AKI alerts
- Add pagination to research studies
- Update Investigation types codes

### Fixed
- Display correct html event notes when toggling events content
- CSS display in Chrome, remove excessive padding at page bottom
- Use UTF8 in PDFs

## 2.0.0.pre.rc12
06-03-2018

### Added
- Use a modal to ask if letter should be marked as printed (ie completed) after printing

### Changed
- Capture the who and when of letter state changes
- Use new database columns to restrict and order the pathology observations to display
- Introduce frozen_string_literal comment in presenters, spec and cucumber features.
  Roll out across the rest of the app later.
- Add Prescriptions to the API

### Fixed
- Removed rogue column in aki_alerts
- FireFox layout fix - we now use flexbox CSS on patient pages
- Remove Print All button on Renal -> Letters. It didn't do anything.
- Use a transaction around HL7 processing to prevent orphaned observations and
  observation_requests if once of the OBXs fails (causing a delayed_job retry).

## 2.0.0.pre.rc12
27-02-2018

### Added
- UKRDC export rake task

### Changed
- Default sort order to HGB desc on all MDMs
- Sort Clinical Studies list
- Add address fields to API
- Limit delayed_job retries to 10 and do not remove from queue once exceeded
- Ensure OBR placer ids are unique in UKRDC XML
- Cache rendered PDFs using Cache::FileStore not the the default Rails.cache

### Fixed

- #1948 Fix patient side menu when patients have markup in event notes

## 2.0.0.pre.rc11
21-02-2018

### Added
- Enable clearing the cache form the app when a super admin
- Add fragment caching in key places
- Add link to approve users at bottom of admin dashboard
- Add postgres dump rake task and configure in schedule.rb (for whenever)
- Add simple API for accessing patient demographics

### Changed
- Improve display of admin users table
- Set default order to HGB date on PD and HD MDMs
- Remove access to some audits for now as performance needs optimising
- Add missing fields to AKI Alerts
- Add unique display_order columns to observation_descriptions to support future ordering

### Fixed
- Changed events order to datetime desc
- Fix display of Test Cancelled in pathology results

## 2.0.0.pre.rc10
13-02-2018

### Added
- Handle display of cancelled OBX tests
- Add psychosocial fields to Demographics

### Changed
- Only list last 10 dates of pathology in MDM. Includes refactor of the Historical Pathology view
to avoid excessive memory usage
- Reduce space taken up in clinical grey bar
- Refactor Clinical Summary view so make it easier to extend in host app
- Update units of measurement and seeds #1924
- Update CAPD bag volumes
- Expand PD Fluid Types list
- Pin gem versions ready for 2.0 release

### Fixed
- Bug when querying for path by OBX codes and codes is null #1936
- Bug where its possible to Back in the browser once logged out #1934
- Bug where no missing obs date in HL7 - now ignores OBX and logs a warning #1926
- Bug where NHS No repeated in MDM table columns

## 2.0.0.pre.rc9
07-02-2018 - Created to debug gem resolution issue.

## 2.0.0.pre.rc8
06-02-2018

### Added
- Clinical grey bar on patient screens, displaying latest key results

### Changed
- Display only 10 path results on MDMs
- Only output OBX results having a loinc_code in UKRDC XML
- Other UKRDC XML changes
- Table column width tweaks

### Fixed
- Add missing deleted_at indexes

## 2.0.0.pre.rc7
29-01-2018

### Added
### Changed
- Email handling when letter approved

### Fixed

## 2.0.0.pre.rc7
29-01-2018

### Added
- Patient Investigations

### Changed
- UKRDC XML changes
- don't display path results on letter if letterhead forbids it

### Fixed
- support HL7 messages with > 1 OBR segment
- set updated_at on pathology_current_observation_sets when jsonb is updated with a new result

## 2.0.0.pre.rc6
16-01-2018

### Added
- EPR support for saving PDF to filesystem
- New drug types
- Support for adding custom links in patient nav

### Changed
- UKRDC XML changes
- Hide un-measured clinical measurements in letters

### Fixed
- HL7 Caret fix

## 2.0.0.pre.rc4
16-01-2018

### Added
- GP and Practice import via file

### Changed

### Fixed
- Minor bug fixes

## 2.0.0.pre.rc4
16-01-2018

### Added
- Support for emailing letter to GP once approved
- Support for emailing letter to an EPR endpoint once approved
- Migrate to Ruby 2.5
- Add Low Clearance Profile and Low Clearance section in Patient Nav

### Changed
- Prefix Alerts with `Alert:` and change styling
- Expire users after 90 days of inactivity
- RSpec housekeeping
- Patient LH Menu made more compact
- Reinstate and improve formatting of NHS logo in letters
- Ensure there is a link to the MDM from each patient

### Fixed
- Mailer previews not displaying
- New clinical letter for patient without recent pathology
- Double render in Tx donor workup #show
- Order of recent investigations (recent pathology) in Letters

## 2.0.0.pre.rc3
18-12-2017

### Added
- Consults

### Changed
- Letter pathology layout

### Fixed

## 2.0.0.pre.rc2
17-12-2017

### Added
- Ability to search for and filter users in Admin -> Users
- Cache latest pathology observations in a new table to speed up displaying current pathology

### Changed
- Change dashboard to display user fullname not username
- Update gems

### Fixed

## 2.0.0.pre.rc1
10-12-2017

### Added
- Beta banner with option to report bug or give feeback

### Changed
- New column on observation_descriptions to capture LOINC code
- Show only 10 letters and events in Clinical Summary with View All option to see the remainder

### Fixed
- Low Clearance MDM now uses `Low Clearance` not 'LCC' modality

## 2.0.0.pre.beta13
01-12-2017

### Added
- Freeze Pathology in Letter
- Low Clearance MDM
- Add Tags to Bookmarks

### Changed
- Housekeeping - new indexes, remove unused code
- Migrate to Cucumber 3

### Fixed

## 2.0.0.pre.beta12
21-11-2017

### Added
- Support running delayed_job as a daemon
- Added `tags` field to Bookmarks

### Changed
- Moved renalware core database objects into the `renalware` postgres schema
- Use lograge for single line logging in production
- Support Postgres 10 on CI and Heroku review apps
- Use a separate log for delayed_job
- Mirth feed processing no longer creates new patients
- Reduce the ajax session expiry polling frequency and don't log those requests

### Fixed
- UKRDC XML changes

## 2.0.0.pre.beta11

### Added

### Changed
- Remove unique index on patient locals_ids to aid data migration
- Moved default drugs seeds to the demo seeds as these are site-specific

### Fixed

## 2.0.0.pre.beta10
07-11-2017

### Added
- Admission Consults
- PD Audit
- Renal Reg return checks
- Clinical Studes
- Anaemia Audit

### Changed

- UKRDC XML improvements

### Fixed

- ESRF address not sticking #1708
- Search by hospital number now case-insensitive
- Pagination admin/users

## 2.0.0.pre.beta9
11-10-2017

### Added

- HD Sesssions in UKRDC XML
- AKI Alert UI
- Add legacy_patient_id to patients table
- Bone audit
- Some seed rationalisation
- Temporary link on patient screen view UKRDC xml
- HD Diary

### Changed

### Fixed

## 2.0.0.pre.beta8
25-09-2017

### Added
- Electronic CCs
- Admission Requests (To Come In list)
- HD Diurnal Periods
- HD Unit Stations
- Forgotten password feature
- Add Pathology to UKRDC XML

### Changed
- Updated to Ruby 2.4.2
- Updated gem dependencies in Nokogiri to fix security warning
- Add dialysis shortfall > 5% to HD Audit
- Update Rails to 5.1.4
- Housekeeping to speed up tests on CI

### Fixed
- Auto session timeout check redirects to / when you are are password reset or signup pages


## 2.0.0.pre.beta7
10-09-2017

### Added
### Changed
### Fixed
- Added the vendor/assets path to the gemspec to fix missing assets when consuming the gem
- Added the spec/support and spec/factories paths to the gemspec to make testing easier in the host

## 2.0.0.pre.beta5

09-09-2017

### Added

Significant additions:
- Patient Alerts
- Private Messaging
- Terminate a patients medications on death
- Automatic logout on session timeout
- Combine Draft and Pending Review letters in the user dashboard
- Event filtering
- Add EPO drugs to HD MDM
- UKRDC XML additions
- Audits
- Patient ESI print-out
- Patient Peritonitis print-out
- PD Line Change events
- Display PD Line changes on the PD Dashboard
- PD Training Sessions
- Add Standing BP to clinic visit
- List HD preference mismatches

### Changed

- Remove Site from Access Profile and Plan
- Styling improvements

### Fixed

- Various bugfixes

## 2.0.0.pre.beta2

### Added

- Add Access Catheter Insertion Techniques to Access Procedure
- Add allergies to clinical letters
- When Clinic visit is printed it hides filters a adds space under each row for notes
- Allow patient search with a comma and no spaces e.g. `Rabb,Rog`
- Events notes field supports bold, italic etc
- Plasma Exchange event type added

### Changed

### Fixed

- Snippets not inserting into event notes field.

## 2.0.0.pre.beta.1

- With this and previous releases, see commits for changes.
