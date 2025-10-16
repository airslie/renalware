# Renalware User Privileges Documentation

**Generated:** 2025-10-16
**Purpose:** Comprehensive documentation of user roles and privileges across the Renalware application

---

## Table of Contents

1. [User Roles Overview](#user-roles-overview)
2. [Role Hierarchy](#role-hierarchy)
3. [Privilege Summary by Role](#privilege-summary-by-role)
4. [Configuration-Based Restrictions](#configuration-based-restrictions)
5. [Detailed Privileges by Domain](#detailed-privileges-by-domain)
6. [Special Authorization Patterns](#special-authorization-patterns)
7. [Time-Based Restrictions](#time-based-restrictions)

---

## User Roles Overview

The Renalware application defines **7 user roles** with different privilege levels and purposes:

### Permission-Level Roles (Hierarchical)

| Role | Description | Visibility | Assignment |
|------|-------------|------------|------------|
| **devops** | System administration, highest privilege | Hidden from UI | Cannot be assigned |
| **super_admin** | Top-level administrative access | Hidden from UI | Cannot be assigned |
| **admin** | Standard administrator | Visible | Can be assigned by super_admin only |
| **clinical** | Clinical staff access | Visible | Can be assigned by admin+ |
| **read_only** | Read-only access | Visible | Can be assigned by admin+ |

### Specialty Roles (Enforceable)

| Role | Description | Enforcement | Assignment |
|------|-------------|-------------|------------|
| **prescriber** | Can prescribe general medications | Configurable via database | Can be assigned by admin+ |
| **hd_prescriber** | Can prescribe HD-specific medications | Configurable via database | Can be assigned by admin+ |

**Note on Enforcement:** When a specialty role is marked as "enforced" in the database, only users with that role (or super_admin) can perform the associated actions. When not enforced, the role becomes advisory only.

**Source Files:**
- Role definitions: `app/models/renalware/role.rb:3`
- Base policy: `app/policies/renalware/base_policy.rb`
- User policy: `app/policies/renalware/user_policy.rb`

---

## Role Hierarchy

```
devops (highest privilege)
  ↓
super_admin
  ↓
admin
  ↓
clinical
  ↓
read_only (lowest privilege)

prescriber ←→ (orthogonal to hierarchy, adds medication privileges)
hd_prescriber ←→ (orthogonal to hierarchy, adds HD medication privileges)
```

### Permission Groups

The application defines several helper methods for checking role groups:

- **`user_is_any_admin?`** → devops OR super_admin OR admin
- **`user_is_at_least_super_admin?`** → devops OR super_admin
- **`write_privileges?`** → devops OR super_admin OR admin OR clinical
- **`has_any_role?`** → User has at least one role assigned

---

## Privilege Summary by Role

### Quick Reference Matrix

| Privilege Type | devops | super_admin | admin | clinical | read_only | prescriber | hd_prescriber |
|----------------|--------|-------------|-------|----------|-----------|------------|---------------|
| **View patients & clinical data** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Create/edit clinical records** | ✓ | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ |
| **Delete clinical records** | ✓ | ✓ | ✓ | ✗* | ✗ | ✗* | ✗* |
| **Manage users** | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ |
| **Assign admin role** | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| **Manage reference data** | ✓ | ✓ | ✓** | ✗ | ✗ | ✗ | ✗ |
| **System configuration** | ✓ | ✓*** | ✗ | ✗ | ✗ | ✗ | ✗ |
| **Prescribe medications** | ✓ | ✓ | ✓**** | ✓**** | ✗ | ✓**** | ✓**** |
| **Prescribe HD medications** | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✓**** |
| **Bypass time windows** | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| **Delete approved letters** | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| **Edit immutable records** | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |

**Notes:**
- \* Some clinical records can be deleted by author within time window
- \** Only some reference data, see Configuration-Based Restrictions
- \*** Config is read-only even for super_admin
- \**** If role enforcement is enabled, requires prescriber/hd_prescriber role

### devops Role

**Full Access To:**
- Everything in the system
- All administrative functions
- All clinical functions
- System cache management
- Background job monitoring

**Restrictions:**
- Cannot be assigned to users (role assignment is blocked)
- Hidden from UI role selection

**Use Case:** System administration, infrastructure management

---

### super_admin Role

**Full Access To:**
- All clinical and administrative functions
- User management (including admin role assignment)
- Reference data management
- System configuration (read-only)
- Can bypass most time window restrictions
- Can delete approved/completed letters
- Can edit/delete records that are normally immutable

**Exclusive Access To (via permissions.yml):**
- Role management (`Renalware::Role`)
- Hospital centres, wards, units
- HD dialysate and dialyser types
- HD cannulation types
- Pathology observation descriptions
- Virology vaccination types
- Outgoing document feeds
- Death locations
- Patient group directions

**Restrictions:**
- Cannot be assigned to users
- Cannot modify system configuration (read-only)
- Hidden from UI role selection

**Use Case:** Top-level system administration

---

### admin Role

**Full Access To:**
- User management (cannot assign admin/super_admin roles)
- Most reference data management
- Most clinical record creation/editing
- Can delete PD adequacy results
- Can edit closed HD sessions (if not immutable)
- Time windows apply (longer than clinical users)

**Exclusive Access To (via permissions.yml):**
- User accounts
- Bag types
- Drug types and drugs
- EDTA codes
- Event types
- Medication routes
- Modality descriptions
- Organism codes
- PRD descriptions
- HD transmission logs
- HD stations

**Admin-Level Access To:**
- Clinic management (view/create)
- Consultant management (view/create)
- Letter mailshots
- Letter topics
- System messages
- Nag definitions
- View metadata management
- Research study management
- Patient worry categories
- Pathology code groups and labs

**Restrictions:**
- Cannot assign admin or super_admin roles
- Cannot bypass all time windows (event-specific config applies)
- Cannot delete approved letters (unless author)
- Cannot edit most reference data after creation (super_admin only)

**Use Case:** Department administrators, senior clinical staff

---

### clinical Role

**Full Access To:**
- Patient viewing (subject to site/study restrictions)
- Clinical record creation and editing
- Letter authoring and management (as author)
- Medication prescribing (if prescriber role also assigned)
- HD session management (open sessions)
- Events, assessments, and clinical observations

**Can Create/Edit:**
- Patient demographics (unless feed-controlled)
- Admissions, consults, requests
- Allergies, body composition data
- Clinic visits (with time window)
- Problems, worries, alerts
- Events (with author time window)
- HD sessions (open only)
- PD assessments, regimes, training sessions
- Transplant workups and operations
- Virology profiles and vaccinations

**Cannot:**
- Delete most records (exceptions: author can delete within time window)
- Manage users or reference data
- Access system configuration
- Manage clinics or consultants (view only)
- Delete approved letters
- Edit closed HD sessions
- Bypass time windows

**Use Case:** Doctors, nurses, clinical staff

---

### read_only Role

**View-Only Access To:**
- Patients and all clinical data
- Letters and correspondence
- Pathology results
- Medication lists (cannot prescribe)
- HD sessions and schedules
- Events and assessments
- Reports and dashboards

**Cannot:**
- Create, edit, or delete anything
- Prescribe medications
- Author letters or events
- Modify patient records
- Access administrative functions

**Use Case:** Auditors, read-only clinical staff, reporting users

---

### prescriber Role

**Additional Privileges:**
- Can prescribe general medications (if enforcement enabled)
- Can create/edit/terminate prescriptions
- Same base privileges as assigned permission-level role

**Enforcement:**
- If `Role.enforce?(:prescriber)` returns true, only users with prescriber/hd_prescriber/super_admin can prescribe
- If enforcement is disabled, all users with write_privileges can prescribe

**Note:** This is a specialty role that works in conjunction with permission-level roles (clinical, admin, etc.)

**Use Case:** Clinicians authorized to prescribe medications

---

### hd_prescriber Role

**Additional Privileges:**
- All prescriber privileges PLUS
- Can prescribe HD-specific medications
- Can administer HD prescriptions
- Can create new HD prescriptions
- Can renew HD prescription batches (if configured)

**Enforcement:**
- If `Role.enforce?(:hd_prescriber)` returns true, only users with hd_prescriber/super_admin can prescribe HD medications
- If enforcement is disabled, prescriber role is sufficient for HD prescriptions

**Note:** This is a specialty role that works in conjunction with permission-level roles

**Use Case:** HD nurses and clinicians authorized to prescribe dialysis medications

---

## Configuration-Based Restrictions

Several system configuration flags modify permission behavior:

### Patient Management

| Configuration Flag | Effect | Affected Roles |
|-------------------|--------|----------------|
| `disable_inputs_controlled_by_demographics_feed` | Only super_admin can create/edit patient demographics | All except super_admin |
| `only_admins_can_update_pkb_renalreg_preferences` | Only admins can update PKB/RenalReg preferences | clinical, read_only |
| `restrict_patient_visibility_by_user_site` | Filters patients by user's hospital centre | All except super_admin |
| `restrict_patient_visibility_by_research_study` | Filters patients by research study participation | All except super_admin |

### Modality Management

| Configuration Flag | Effect | Affected Roles |
|-------------------|--------|----------------|
| `allow_modality_history_amendments` | Admins can edit/delete modality history | Enables for admin/super_admin/devops |

### HD Prescription Management

| Configuration Flag | Effect | Affected Roles |
|-------------------|--------|----------------|
| `auto_terminate_hd_prescriptions_after_period` | Enables HD prescription batch renewal feature | Enables index? for all, create? for hd_prescriber |

### Event-Specific Configuration

Each event type can configure:

| Event Type Setting | Effect |
|-------------------|--------|
| `author_change_window_hours` | Hours author can edit (0=never, -1=forever) |
| `admin_change_window_hours` | Hours admin can edit (0=never, -1=forever) |
| `superadmin_can_always_change` | Whether super_admin bypasses time windows |
| `save_pdf_to_electronic_public_register` | Prevents editing/deleting (EPR immutability) |

---

## Detailed Privileges by Domain

### 1. ADMINISTRATION

#### User Management

**Policy:** `UserPolicy` (app/policies/renalware/user_policy.rb)
**Restricted Model:** Yes (admin+ via permissions.yml)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View users | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create users | ✓ | ✓ | ✓ | ✗ | ✗ |
| Edit users | ✓* | ✓* | ✓* | ✗ | ✗ |
| Delete users | ✓ | ✓ | ✓ | ✗ | ✗ |
| Assign devops role | ✗ | ✗ | ✗ | ✗ | ✗ |
| Assign super_admin role | ✗ | ✗ | ✗ | ✗ | ✗ |
| Assign admin role | ✗ | ✓ | ✗ | ✗ | ✗ |
| Assign other roles | ✓ | ✓ | ✓ | ✗ | ✗ |

**Special Conditions:**
- Cannot edit self
- Cannot assign hidden roles (devops, super_admin)

#### Role Management

**Policy:** `BasePolicy` with permissions.yml restriction
**Restricted Model:** Yes (super_admin only)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| All actions | ✓ | ✓ | ✗ | ✗ | ✗ |

#### Cache Management

**Policy:** `Admin::CachePolicy` (app/policies/renalware/admin/cache_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View cache | ✓ | ✓ | ✗ | ✗ | ✗ |
| Clear cache | ✓ | ✓ | ✗ | ✗ | ✗ |

#### System Configuration

**Policy:** `Admin::ConfigPolicy` (app/policies/renalware/admin/config_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View config | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit config | ✗ | ✗ | ✗ | ✗ | ✗ |

**Note:** Configuration is read-only for all roles (managed via ENV/files)

#### Devops Functions

**Policy:** `Admin::DevopsPolicy` (app/policies/renalware/admin/devops_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| All actions | ✓ | ✓ | ✗ | ✗ | ✗ |

---

### 2. PATIENTS

#### Patient Records

**Policy:** `Patients::PatientPolicy` (app/policies/renalware/patients/patient_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View patients | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create patients | ✓ | ✓ | ✓* | ✓* | ✗ |
| Edit patients | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete patients | ✓ | ✓ | ✓ | ✓ | ✗ |
| Update demographics | ✓ | ✓* | ✓* | ✓* | ✗ |
| Update PKB/RenalReg preferences | ✓ | ✓** | ✓** | ✓** | ✗ |

**Special Conditions:**
- \* If `disable_inputs_controlled_by_demographics_feed` is enabled, only super_admin can create/update demographics
- \** If `only_admins_can_update_pkb_renalreg_preferences` is enabled, only admins can update preferences

**Patient Visibility Scope:**
- **super_admin:** Sees all patients
- **Others:** Filtered by:
  - Hospital centre (if `restrict_patient_visibility_by_user_site?`)
  - Research study participation (if `restrict_patient_visibility_by_research_study?`)
  - Users at host site see all patients at that site
  - Users at non-host sites see patients at their site who are not in private studies
  - Users see patients in private studies if they are investigators

#### Patient Alerts

**Policy:** `Patients::AlertPolicy` (app/policies/renalware/patients/alert_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View alerts | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create alerts | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit alerts | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete alerts | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Patient Worries

**Policy:** `Patients::WorryPolicy` (app/policies/renalware/patients/worry_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View worries | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create worries | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit worries | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete worries | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Worry Categories

**Policy:** `Patients::WorryCategoryPolicy` (app/policies/renalware/patients/worry_category_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View categories | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create categories | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit categories | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete categories | ✓* | ✓* | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Edit/delete only if persisted and not deleted

#### Patient Bookmarks

**Policy:** `Patients::BookmarkPolicy` (app/policies/renalware/patients/bookmark_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create bookmark | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete bookmark | ✓* | ✓* | ✓* | ✓* | ✗ |

**Special Conditions:**
- \* Can only delete own bookmarks

#### Patient Attachments & Timeline

**Policies:** `Patients::AttachmentPolicy`, `Patients::TimelinePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 3. MEDICATIONS

#### Prescriptions

**Policy:** `Medications::PrescriptionPolicy` (app/policies/renalware/medications/prescription_policy.rb)

| Action | devops | super_admin | admin | clinical | read_only | prescriber | hd_prescriber |
|--------|--------|-------------|-------|----------|-----------|------------|---------------|
| View prescriptions | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create prescription | ✓ | ✓ | ✓* | ✓* | ✗ | ✓* | ✓* |
| Edit prescription | ✓ | ✓ | ✓** | ✓** | ✗ | ✓** | ✓** |
| Delete prescription | ✓ | ✓ | ✓** | ✓** | ✗ | ✓** | ✓** |
| Create HD prescription | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✓*** |

**Prescriber Enforcement:**
- If `Role.enforce?(:prescriber)` is true:
  - \* Requires prescriber OR hd_prescriber OR super_admin role
- If enforcement is disabled:
  - \* Any user with write_privileges can prescribe

**HD Prescriber Enforcement:**
- If `Role.enforce?(:hd_prescriber)` is true:
  - \** For HD prescriptions, requires hd_prescriber OR super_admin role
  - \** For non-HD prescriptions, requires prescriber OR hd_prescriber OR super_admin role
  - \*** Requires hd_prescriber OR super_admin role
- If enforcement is disabled:
  - \** Requires prescriber role (or enforcement disabled)
  - \*** Requires prescriber role (or enforcement disabled)

#### HD Prescription Batch Renewal

**Policy:** `Medications::PrescriptionBatchRenewalPolicy`

| Action | devops | super_admin | admin | clinical | read_only | hd_prescriber |
|--------|--------|-------------|-------|----------|-----------|---------------|
| View batch renewals | ✓* | ✓* | ✓* | ✓* | ✓* | ✓* |
| Create batch renewal | ✓** | ✓** | ✗ | ✗ | ✗ | ✓** |

**Special Conditions:**
- \* View only if `auto_terminate_hd_prescriptions_after_period` config is set
- \** Create only if config enabled AND hd_prescriber check passes

#### Medication Reviews

**Policy:** `Medications::ReviewPolicy` (inherits from Events::EventPolicy)

See Events section for time window restrictions.

#### Drug Management

**Policy:** `Drugs::DrugPolicy` (app/policies/renalware/drugs/drug_policy.rb)
**Restricted Model:** Yes (admin+ via permissions.yml)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View drugs | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create drugs | ✓ | ✓ | ✓ | ✗ | ✗ |
| Edit drugs | ✓ | ✓ | ✓ | ✗ | ✗ |
| Delete drugs | ✓ | ✓ | ✓ | ✗ | ✗ |
| View selected drugs | ✓ | ✓ | ✓ | ✓ | ✗ |
| View prescribable drugs | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 4. LETTERS

#### Letter Workflow

**Policy:** `Letters::LetterPolicy` (base for all letter states)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View letters | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create letter | ✓ | ✓ | ✓ | ✓ | ✗ |
| Author letter | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete letter | ✓* | ✓* | ✓** | ✓** | ✗ |
| View deleted letters | ✓ | ✓ | ✗ | ✗ | ✗ |

**Delete Conditions:**
- \* Can delete approved/completed letters (super_admin only)
- \** Can delete draft/pending letters if admin/super_admin OR author OR creator

#### Draft Letters

**Policy:** `Letters::DraftLetterPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Edit draft | ✓ | ✓ | ✓ | ✓ | ✗ |
| Submit for review | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Pending Review Letters

**Policy:** `Letters::PendingReviewLetterPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Approve | ✓ | ✓ | ✓ | ✓ | ✗ |
| Reject | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Approved Letters

**Policy:** `Letters::ApprovedLetterPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Complete | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Letter Topics

**Policy:** `Letters::TopicPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View topics | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create topics | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit topics | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete topics | ✓* | ✓* | ✗ | ✗ | ✗ |
| Sort topics | ✓ | ✓ | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Only if not deleted

#### Letter Mailshots

**Policy:** `Letters::Mailshots::MailshotPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View mailshots | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create mailshots | ✓ | ✓ | ✗ | ✗ | ✗ |

#### Electronic Receipts

**Policy:** `Letters::ElectronicReceiptPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Mark as read | ✓* | ✓* | ✓* | ✓* | ✗ |
| View unread | ✓ | ✓ | ✓ | ✓ | ✓ |
| View read | ✓ | ✓ | ✓ | ✓ | ✓ |
| View sent | ✓ | ✓ | ✓ | ✓ | ✓ |

**Special Conditions:**
- \* Can mark as read only if unread AND letter is approved/completed

---

### 5. EVENTS

#### Event Management

**Policy:** `Events::EventPolicy` (base for most event types)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View events | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create events | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit events | ✓* | ✓* | ✓** | ✓*** | ✗ |
| Delete events | ✓**** | ✓**** | ✓***** | ✗ | ✗ |

**Edit Permissions (complex time-based logic):**
- FALSE if event saved to EPR (`save_pdf_to_electronic_public_register?`)
- \* TRUE if super_admin AND event type allows `superadmin_can_always_change`
- \** TRUE if admin AND within `admin_change_window_hours`
- \*** TRUE if author AND within `author_change_window_hours`

**Delete Permissions:**
- \**** super_admin can delete events sent to EPR
- \***** Otherwise same conditions as edit

**Event Types Using EventPolicy:**
- AdvancedCarePlanPolicy
- BiopsyPolicy
- ClinicalFrailtyScorePolicy
- SimplePolicy
- SwabPolicy
- Clinical::DukeActivityStatusIndexPolicy
- Medications::ReviewPolicy
- Transplants::ReviewPolicy
- Virology::VaccinationPolicy
- Research::StudyEventPolicy

#### Investigation Events

**Policy:** `Events::InvestigationPolicy` (inherits from EventPolicy)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Edit investigations | ✓ | ✓ | ✓ | ✓ | ✗ |

**Special:** Always allows edit/update (bypasses time windows)

#### Event Types Management

**Policy:** `Events::TypePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View event types | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create event types | ✓ | ✓ | ✓ | ✓ | ✓ |
| Edit event types | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete event types | ✓** | ✓** | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Edit only if not deleted
- \** Delete only if no slug and not deleted

---

### 6. HEMODIALYSIS (HD)

#### HD Sessions

**Base Policy:** `HD::SessionPolicy` (very restrictive base)

| Action | All Roles |
|--------|-----------|
| Create/edit/delete | ✗ |

**Open Sessions:**

**Policy:** `HD::OpenSessionPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create session | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit session | ✓* | ✓* | ✓* | ✓* | ✗ |
| Delete session | ✓* | ✓* | ✓* | ✓* | ✗ |

**Special Conditions:**
- \* Only if session is persisted

**DNA Sessions:**

**Policy:** `HD::DNASessionPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create session | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit session | ✓ | ✓ | ✓* | ✓* | ✗ |
| Delete session | ✓ | ✓ | ✓* | ✓* | ✗ |

**Special Conditions:**
- \* Only if persisted AND not immutable

**Closed Sessions:**

**Policy:** `HD::ClosedSessionPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create session | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit session | ✓ | ✓ | ✓* | ✗ | ✗ |
| Delete session | ✓ | ✓ | ✓* | ✗ | ✗ |

**Special Conditions:**
- \* Admin can edit/delete if persisted AND not immutable

#### HD Prescription Administration

**Policy:** `HD::PrescriptionAdministrationPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✓ |
| Delete | ✓ | ✓ | ✓ | ✗ | ✗ |

**Note:** Unusually permissive - allows read_only to create/edit (likely for session recording)

#### HD Acuity Assessments

**Policy:** `HD::AcuityAssessmentPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create assessment | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit assessment | ✓* | ✓ | ✓* | ✓* | ✗ |
| Delete assessment | ✓** | ✓ | ✓** | ✓** | ✗ |

**Time Window Restrictions:**
- \* Edit only if within `hd_acuity_assessment_edit_window` OR super_admin
- \** Delete only if (author OR super_admin) AND within `hd_acuity_assessment_deletion_window`

#### VND Risk Assessments

**Policy:** `HD::VNDRiskAssessmentPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create assessment | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit assessment | ✗ | ✗ | ✗ | ✗ | ✗ |
| Delete assessment | ✓* | ✗ | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Only author can delete (no time window)
- Edit explicitly disabled

#### HD Stations

**Policy:** `HD::StationPolicy`
**Restricted Model:** Yes (admin+ via permissions.yml)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View stations | ✓ | ✓ | ✓ | ✓ | ✓ |
| Sort stations | ✓ | ✓ | ✓ | ✓ | ✗ |

#### HD Reference Data

**Policies:** Dialysate, Dialyser, CannulationType
**Restricted Model:** Yes (super_admin only via permissions.yml)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| All actions | ✓ | ✓ | ✗ | ✗ | ✗ |

#### HD Scheduling

**Policy:** `HD::Scheduling::DiaryPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View diary | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit diary | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 7. PERITONEAL DIALYSIS (PD)

#### PD Assessments, Training, Episodes

**Policies:** AssessmentPolicy, PeritonitisEpisodePolicy, TrainingSessionPolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

#### PD Regimes

**Policy:** `PD::RegimePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create regime | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit regime | ✓* | ✓* | ✓* | ✓* | ✗ |

**Special Conditions:**
- \* Can only edit current regimes (not historical)

#### PD Adequacy Results

**Policies:** AdequacyResultPolicy, PETResultPolicy, PETAdequacyResultPolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View results | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit results | ✓ | ✓ | ✓ | ✓ | ✓ |
| Delete results | ✓ | ✓ | ✓ | ✗ | ✗ |

**Note:** Unusually allows read_only to create/edit (likely for data entry)

---

### 8. TRANSPLANTS

#### Transplant Workups & Operations

**Policies:** RecipientWorkupPolicy, RecipientOperationPolicy, DonorStagePolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓* | ✓* | ✓* | ✓* | ✗ |
| Edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

**Special Conditions:**
- \* Create (new?) only if record is new (not persisted)

#### Transplant Registrations

**Policy:** `Transplants::RegistrationPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓* | ✓* | ✓* | ✓* | ✗ |
| Edit | ✓ | ✓ | ✓ | ✓ | ✗ |

**Special Conditions:**
- \* Create (new?) only if record is new

#### Rejection Episodes

**Policy:** `Transplants::RejectionEpisodePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓* | ✓* | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Delete only if not persisted OR devops/super_admin

#### Transplant Followups & Reviews

**Policies:** RecipientFollowupPolicy, ReviewPolicy (inherits EventPolicy)

See standard BasePolicy and Events sections for permissions.

---

### 9. CLINICS

#### Clinic Management

**Policy:** `Clinics::ClinicPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View clinics | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create clinics | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit clinics | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete clinics | ✓* | ✓* | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Edit/delete only if persisted and not deleted

#### Consultant Management

**Policy:** `Clinics::ConsultantPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View consultants | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create consultants | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit consultants | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete consultants | ✓* | ✓* | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Edit/delete only if persisted and not deleted

#### Clinic Visits

**Policy:** `Clinics::ClinicVisitPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create visit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Edit visit | ✓* | ✓ | ✓* | ✓* | ✗ |
| Delete visit | ✓** | ✓ | ✓** | ✓** | ✗ |

**Time Window Restrictions:**
- \* Edit only if (author OR super_admin) AND within `new_clinic_visit_edit_window`
- \** Delete only if (author OR super_admin) AND within `new_clinic_visit_deletion_window`

#### Clinic Appointments

**Policy:** `Clinics::AppointmentPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 10. PATHOLOGY

#### Pathology Labs

**Policy:** `Pathology::LabPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View labs | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create labs | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit labs | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete labs | ✓* | ✓* | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Edit/delete only if persisted

#### Pathology Code Groups

**Policy:** `Pathology::CodeGroupPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View code groups | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit/delete | ✓ | ✓ | ✗ | ✗ | ✗ |

#### Observation Descriptions

**Policy:** BasePolicy with permissions.yml restriction
**Restricted Model:** Yes (super_admin only)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| All actions | ✓ | ✓ | ✗ | ✗ | ✗ |

#### Pathology Requests

**Policies:** RequestPolicy, GlobalRuleSetPolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 11. ADMISSIONS

#### Admissions, Consults, Requests

**Policies:** AdmissionPolicy, ConsultPolicy, RequestPolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 12. VIROLOGY

#### Virology Profiles & Dashboards

**Policies:** ProfilePolicy, DashboardPolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Vaccinations

**Policy:** `Virology::VaccinationPolicy` (inherits from EventPolicy)

See Events section for time window restrictions.

#### Vaccination Types

**Policy:** BasePolicy with permissions.yml restriction
**Restricted Model:** Yes (super_admin only)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| All actions | ✓ | ✓ | ✗ | ✗ | ✗ |

---

### 13. MODALITIES

#### Modality Descriptions

**Policy:** `Modalities::DescriptionPolicy`
**Restricted Model:** Yes (admin+ via permissions.yml)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View descriptions | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create descriptions | ✓ | ✓ | ✗ | ✗ | ✗ |
| Edit descriptions | ✓* | ✓* | ✗ | ✗ | ✗ |
| Delete descriptions | ✗ | ✗ | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Edit only if record.type is nil (non-STI descriptions)
- Delete explicitly disabled for safety

#### Modality History

**Policy:** `Modalities::ModalityPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View modalities | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create modalities | ✓ | ✓ | ✓ | ✓ | ✓ |
| Edit modalities | ✓* | ✓* | ✓* | ✗ | ✗ |
| Delete modalities | ✓* | ✓* | ✓* | ✗ | ✗ |

**Special Conditions:**
- \* Edit/delete only if `allow_modality_history_amendments` config is true AND user_is_any_admin

---

### 14. RESEARCH (Pack Module)

#### Research Studies

**Policy:** `Research::StudyPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View studies | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create studies | ✓ | ✓ | ✓ | ✗ | ✗ |
| Edit studies | ✓ | ✓ | ✓ | ✗ | ✗ |
| Delete studies | ✓ | ✓ | ✓ | ✗ | ✗ |

#### Research Investigatorships

**Policy:** `Research::InvestigatorshipPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View investigatorships | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create investigatorships | ✓ | ✓* | ✗ | ✗ | ✗ |
| Edit investigatorships | ✓ | ✓* | ✗ | ✗ | ✗ |
| Delete investigatorships | ✓ | ✓* | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* super_admin OR study manager for that study

#### Research Participations

**Policy:** `Research::ParticipationPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View participations | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create participations | ✓ | ✓* | ✗ | ✗ | ✗ |
| Edit participations | ✓ | ✓* | ✗ | ✗ | ✗ |
| Delete participations | ✓ | ✓** | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* super_admin OR study investigator for that study
- \** super_admin OR study manager for that study

#### Study Events

**Policy:** `Research::StudyEventPolicy` (inherits from EventPolicy)

See Events section for time window restrictions.

---

### 15. CLINICAL DATA

#### Allergies & Body Composition

**Policies:** Clinical::AllergyPolicy, Clinical::BodyCompositionPolicy

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Duke Activity Status Index

**Policy:** `Clinical::DukeActivityStatusIndexPolicy` (inherits from EventPolicy)

See Events section for time window restrictions.

#### Accesses - Needling Assessments

**Policy:** `Accesses::NeedlingAssessmentPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Create assessment | ✓ | ✓ | ✓ | ✓ | ✗ |
| View assessment | ✗ | ✗ | ✗ | ✗ | ✗ |
| Edit assessment | ✗ | ✗ | ✗ | ✗ | ✗ |
| Delete assessment | ✓* | ✓ | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Delete only if (author OR super_admin) AND within deletion window
- View/edit explicitly disabled (unusual)

#### Low Clearance Profiles

**Policy:** `LowClearance::ProfilePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Edit profile | ✓* | ✓* | ✓* | ✓* | ✗ |

**Special Conditions:**
- \* Edit only if record present AND patient ever been on low clearance AND has update permission

#### Problems

**Policy:** `Problems::ProblemPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |
| Sort | ✓ | ✓ | ✓ | ✓ | ✗ |
| Search | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Renal - AKI Alerts

**Policy:** `Renal::AKIAlertPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Renal - Registry Preflight Checks

**Policy:** `Renal::RegistryPreflightCheckPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View checks | ✓ | ✓ | ✓ | ✓ | ✓ |
| Check deaths | ✓ | ✓ | ✓ | ✓ | ✓ |
| Check patients | ✓ | ✓ | ✓ | ✓ | ✓ |
| Check missing ESRF | ✓ | ✓ | ✓ | ✓ | ✓ |

---

### 16. SYSTEM

#### System Messages

**Policy:** `System::MessagePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View messages | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create messages | ✓ | ✓ | ✗ | ✗ | ✗ |
| Delete messages | ✓ | ✓ | ✗ | ✗ | ✗ |

#### System Downloads

**Policy:** `System::DownloadPolicy`
**Restricted Model:** Yes (super_admin only via permissions.yml)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View downloads | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create downloads | ✓ | ✓ | ✗ | ✗ | ✗ |
| Delete downloads | ✓ | ✓ | ✗ | ✗ | ✗ |

#### Nag Definitions

**Policy:** `System::NagDefinitionPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View nags | ✓ | ✓ | ✓ | ✗ | ✗ |
| Create/edit nags | ✓ | ✓ | ✗ | ✗ | ✗ |

#### User Feedback

**Policy:** `System::UserFeedbackPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View feedback | ✓ | ✓ | ✗ | ✗ | ✗ |

#### View Metadata

**Policy:** `System::ViewMetadataPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View metadata | ✓ | ✓ | ✓ | ✓ | ✓ |
| View chart | ✓ | ✓ | ✓ | ✓ | ✓ |
| View content | ✓ | ✓ | ✓ | ✓ | ✓ |
| Edit metadata | ✓ | ✓ | ✗ | ✗ | ✗ |
| Restore metadata | ✓ | ✓ | ✗ | ✗ | ✗ |

#### Online Reference Links

**Policy:** `System::OnlineReferenceLinkPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Search | ✓ | ✓ | ✓ | ✓ | ✓ |

---

### 17. MESSAGING

#### Internal Messages

**Policy:** `Messaging::Internal::MessagePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

#### Message Receipts

**Policy:** `Messaging::Internal::ReceiptPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| Mark as read | ✓ | ✓ | ✓ | ✓ | ✗ |
| View unread | ✓ | ✓ | ✓ | ✓ | ✓ |
| View read | ✓ | ✓ | ✓ | ✓ | ✓ |
| View sent | ✓ | ✓ | ✓ | ✓ | ✓ |

---

### 18. SURVEYS

#### Surveys

**Policy:** `Surveys::SurveyPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 19. HOSPITALS (Pack Module)

#### Hospital Wards

**Policy:** `Hospitals::WardPolicy`
**Restricted Model:** Yes (super_admin only via permissions.yml for create/edit/delete)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View wards | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit/delete | ✓ | ✓ | ✗ | ✗ | ✗ |

---

### 20. AUTHORING (Pack Module)

#### Snippets

**Policy:** `Authoring::SnippetPolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create/edit | ✓ | ✓ | ✓ | ✓ | ✗ |
| Delete | ✓ | ✓ | ✓ | ✓ | ✗ |

---

### 21. FEEDS

#### Feed Files

**Policy:** `Feeds::FilePolicy`

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| View files | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create files | developer* | developer* | ✗ | ✗ | ✗ |
| Edit files | ✗ | ✗ | ✗ | ✗ | ✗ |
| Delete files | ✗ | ✗ | ✗ | ✗ | ✗ |

**Special Conditions:**
- \* Uses `developer?` method (not standard role check)

#### Outgoing Documents

**Policy:** BasePolicy with permissions.yml restriction
**Restricted Model:** Yes (super_admin only)

| Action | devops | super_admin | admin | clinical | read_only |
|--------|--------|-------------|-------|----------|-----------|
| All actions | ✓ | ✓ | ✗ | ✗ | ✗ |

---

## Special Authorization Patterns

### 1. Author-Based Permissions

Several policies grant special privileges to the record creator within time windows:

#### Clinic Visits
- **Author can edit** within `new_clinic_visit_edit_window`
- **Author can delete** within `new_clinic_visit_deletion_window`
- **super_admin** can always edit/delete

#### HD Acuity Assessments
- **Author can edit** within `hd_acuity_assessment_edit_window`
- **Author can delete** within `hd_acuity_assessment_deletion_window`
- **super_admin** can always edit/delete

#### Needling Assessments
- **Author can delete** within `new_clinic_visit_deletion_window`
- **super_admin** can always delete

#### VND Risk Assessments
- **Only author can delete** (no time window)
- **Edit is disabled** for everyone

#### Events
- **Author can edit/delete** within `author_change_window_hours` (per event type)
- **Admin can edit/delete** within `admin_change_window_hours` (per event type)
- **super_admin** can bypass if `superadmin_can_always_change` is true

#### Letters
- **Author can delete** draft/pending letters
- **Only super_admin** can delete approved/completed letters

### 2. State-Based Permissions

#### Letter Workflow

Letters transition through states with different permissions:

| State | Can Edit | Can Submit for Review | Can Approve | Can Reject | Can Complete | Can Delete |
|-------|----------|----------------------|-------------|------------|--------------|------------|
| **Draft** | Author, write_privileges | Author, write_privileges | ✗ | ✗ | ✗ | Author, admin+ |
| **Pending Review** | write_privileges | ✗ | write_privileges | write_privileges | ✗ | Author, admin+ |
| **Approved** | ✗ | ✗ | ✗ | ✗ | write_privileges | super_admin only |
| **Completed** | ✗ | ✗ | ✗ | ✗ | ✗ | super_admin only |

#### HD Sessions

Sessions have different types with different mutability:

| Session Type | Can Edit | Can Delete |
|--------------|----------|------------|
| **Open** | write_privileges (if persisted) | write_privileges (if persisted) |
| **DNA** | super_admin OR (write_privileges if not immutable) | super_admin OR (write_privileges if not immutable) |
| **Closed** | any_admin OR (write_privileges if not immutable) | any_admin OR (write_privileges if not immutable) |

#### PD Regimes

| Regime State | Can Edit |
|--------------|----------|
| **Current** | write_privileges |
| **Historical** | ✗ |

### 3. Research Study-Based Permissions

Research studies introduce role-based permissions based on investigatorship:

| Role in Study | Can Create Participations | Can Edit Participations | Can Delete Participations | Can Manage Investigatorships |
|---------------|--------------------------|------------------------|--------------------------|----------------------------|
| **Investigator** | ✓ | ✓ | ✗ | ✗ |
| **Manager** | ✓ | ✓ | ✓ | ✓ |
| **super_admin** | ✓ | ✓ | ✓ | ✓ |
| **admin** | ✓ (study-level) | ✓ (study-level) | ✓ (study-level) | ✗ |

**Patient Visibility:**
- If `restrict_patient_visibility_by_research_study?` is enabled:
  - Users at host site see all patients at that site
  - Users at non-host sites see patients at their site who are not in private studies
  - Users see patients in private studies if they are investigators in that study

### 4. Configuration-Driven Behavior

#### Demographics Feed Control

When `disable_inputs_controlled_by_demographics_feed` is enabled:
- Only **super_admin** can create/edit patient demographics
- All other roles are read-only for patient creation and demographic updates

#### Modality Amendment Control

When `allow_modality_history_amendments` is enabled:
- **any_admin** roles can edit/delete modality history
- When disabled, modality history is immutable (except for super_admin via other means)

#### HD Prescription Batch Renewals

When `auto_terminate_hd_prescriptions_after_period` is configured:
- **hd_prescriber** can create batch renewals
- All roles can view batch renewals

#### PKB/RenalReg Preferences

When `only_admins_can_update_pkb_renalreg_preferences` is enabled:
- Only **any_admin** roles can update preferences
- When disabled, anyone with edit permission can update

### 5. Role Enforcement

#### Prescriber Enforcement

When `Role.enforce?(:prescriber)` returns true:
- Only users with **prescriber**, **hd_prescriber**, or **super_admin** role can prescribe general medications
- When false, any user with **write_privileges** can prescribe

#### HD Prescriber Enforcement

When `Role.enforce?(:hd_prescriber)` returns true:
- Only users with **hd_prescriber** or **super_admin** role can prescribe HD medications
- When false, users with **prescriber** role can prescribe HD medications

### 6. Immutability Patterns

#### EPR (Electronic Public Register) Immutability

Events sent to EPR (`save_pdf_to_electronic_public_register?` is true):
- Cannot be edited by anyone (except super_admin for deletion)
- **super_admin** can delete EPR events

#### HD Session Immutability

Sessions marked as `immutable?`:
- **DNA sessions:** Only super_admin can edit/delete
- **Closed sessions:** Only any_admin can edit/delete
- **Open sessions:** Not affected by immutability

#### Record Deletion Protection

Many reference data models prevent deletion even for super_admin:
- Modality descriptions (always false)
- System config (always false for edit)
- Some event types (only if no slug and not deleted)

---

## Time-Based Restrictions

### Configuration by Record Type

| Record Type | Edit Window Config | Delete Window Config | Who Gets Extended Access |
|-------------|-------------------|---------------------|-------------------------|
| **Clinic Visits** | `new_clinic_visit_edit_window` | `new_clinic_visit_deletion_window` | Author or super_admin |
| **HD Acuity Assessments** | `hd_acuity_assessment_edit_window` | `hd_acuity_assessment_deletion_window` | Author or super_admin |
| **Needling Assessments** | N/A | `new_clinic_visit_deletion_window` | Author or super_admin |
| **Events** | Per event type: `author_change_window_hours`, `admin_change_window_hours` | Same as edit | Author (author window), Admin (admin window), super_admin (if configured) |

### Event Type Time Windows

Each event type can configure separate time windows:

| Event Type Setting | Values | Behavior |
|-------------------|--------|----------|
| `author_change_window_hours` | `0` | Author can never edit |
| | `-1` | Author can always edit |
| | `N` | Author can edit for N hours |
| `admin_change_window_hours` | `0` | Admin can never edit |
| | `-1` | Admin can always edit |
| | `N` | Admin can edit for N hours |
| `superadmin_can_always_change` | `true` | super_admin bypasses time windows |
| | `false` | super_admin subject to time windows |

### Time Window Bypass

**super_admin** can bypass time windows when:
- Event type has `superadmin_can_always_change: true`
- For clinic visits, needling assessments, HD acuity assessments (always)
- For VND risk assessments (never - even super_admin cannot edit)

**devops** can always bypass time windows (same as super_admin)

---

## Summary of Privilege Escalation

### From read_only to clinical
- Gains: Create/edit/delete privileges for most clinical records
- Restrictions: Still cannot delete many records, manage users, or access admin functions

### From clinical to admin
- Gains: User management, reference data management, longer time windows, can delete more records
- Restrictions: Cannot assign admin/super_admin roles, cannot access some system functions

### From admin to super_admin
- Gains: Can assign admin role, bypass many restrictions, edit/delete immutable records, access all reference data
- Restrictions: Cannot be assigned (must be set manually), still cannot edit system config

### From super_admin to devops
- Gains: Minimal additional privileges (both have near-total access)
- Use case: System administration vs application administration

### Adding prescriber role
- Gains: Can prescribe general medications (if enforcement enabled)
- Orthogonal to permission-level hierarchy

### Adding hd_prescriber role
- Gains: Can prescribe HD-specific medications (if enforcement enabled)
- Includes all prescriber privileges
- Orthogonal to permission-level hierarchy

---

## Appendix: Complete Reference Data Access Matrix

| Model | super_admin | admin | clinical | read_only | Notes |
|-------|-------------|-------|----------|-----------|-------|
| `Role` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `User` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Hospitals::Ward` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `Hospitals::Centre` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `Hospitals::Unit` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `HD::Dialysate` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `HD::Dialyser` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `HD::CannulationType` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `HD::Station` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `HD::TransmissionLog` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Drugs::Drug` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Drugs::Type` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Events::Type` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Modality::Description` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Pathology::ObservationDescription` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `Virology::VaccinationType` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `System::Download` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `Feeds::OutgoingDocument` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `Deaths::Location` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |
| `BagType` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `EdtaCode` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `MedicationRoute` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `OrganismCode` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `PRDDescription` | ✓ | ✓ | ✗ | ✗ | Admin+ via permissions.yml |
| `Drugs::PatientGroupDirection` | ✓ | ✗ | ✗ | ✗ | Super admin only via permissions.yml |

**Note:** All restricted models additionally allow devops role.

---

## Policy File Index

**Total Policies:** 105

**Core Policies (3):**
- `ApplicationPolicy` - Pundit base
- `BasePolicy` - Renalware base with role checks
- `YAMLPermissionConfiguration` - YAML config handler

**Domain Policies (98):**

**Accesses (1):**
- `Accesses::NeedlingAssessmentPolicy`

**Admin (3):**
- `Admin::CachePolicy`
- `Admin::ConfigPolicy`
- `Admin::DevopsPolicy`

**Admissions (3):**
- `Admissions::AdmissionPolicy`
- `Admissions::ConsultPolicy`
- `Admissions::RequestPolicy`

**Clinical (3):**
- `Clinical::AllergyPolicy`
- `Clinical::BodyCompositionPolicy`
- `Clinical::DukeActivityStatusIndexPolicy`

**Clinics (4):**
- `Clinics::AppointmentPolicy`
- `Clinics::ClinicPolicy`
- `Clinics::ClinicVisitPolicy`
- `Clinics::ConsultantPolicy`

**Drugs (1):**
- `Drugs::DrugPolicy`

**Events (8):**
- `Events::EventPolicy` (base)
- `Events::AdvancedCarePlanPolicy`
- `Events::BiopsyPolicy`
- `Events::ClinicalFrailtyScorePolicy`
- `Events::InvestigationPolicy`
- `Events::SimplePolicy`
- `Events::SubtypePolicy`
- `Events::SwabPolicy`
- `Events::TypePolicy`

**Feeds (1):**
- `Feeds::FilePolicy`

**HD (11):**
- `HD::SessionPolicy` (base)
- `HD::AcuityAssessmentPolicy`
- `HD::ClosedSessionPolicy`
- `HD::DialysatePolicy`
- `HD::DNASessionPolicy`
- `HD::OpenSessionPolicy`
- `HD::PrescriptionAdministrationPolicy`
- `HD::StationPolicy`
- `HD::VNDRiskAssessmentPolicy`
- `HD::Scheduling::DiaryPolicy`
- `HD::SessionForms::BatchPolicy`
- `HD::SlotRequestPolicy`

**Letters (11):**
- `Letters::LetterPolicy` (base)
- `Letters::ApprovedLetterPolicy`
- `Letters::BatchPolicy`
- `Letters::CompletedLetterPolicy`
- `Letters::DraftLetterPolicy`
- `Letters::ElectronicReceiptPolicy`
- `Letters::PendingReviewLetterPolicy`
- `Letters::TopicPolicy`
- `Letters::Mailshots::MailshotPolicy`
- `Letters::Transports::Mesh::OperationPolicy`

**Low Clearance (1):**
- `LowClearance::ProfilePolicy`

**Medications (3):**
- `Medications::PrescriptionPolicy`
- `Medications::PrescriptionBatchRenewalPolicy`
- `Medications::ReviewPolicy`

**Messaging (2):**
- `Messaging::Internal::MessagePolicy`
- `Messaging::Internal::ReceiptPolicy`

**Modalities (2):**
- `Modalities::DescriptionPolicy`
- `Modalities::ModalityPolicy`

**Pathology (4):**
- `Pathology::CodeGroupPolicy`
- `Pathology::LabPolicy`
- `Pathology::Requests::GlobalRuleSetPolicy`
- `Pathology::Requests::RequestPolicy`

**Patients (9):**
- `Patients::PatientPolicy` (with Scope)
- `Patients::AlertPolicy`
- `Patients::AttachmentPolicy`
- `Patients::BookmarkPolicy`
- `Patients::PracticePolicy`
- `Patients::PrimaryCarePhysicianPolicy`
- `Patients::TimelinePolicy`
- `Patients::WorryPolicy`
- `Patients::WorryCategoryPolicy`

**PD (7):**
- `PD::AdequacyResultPolicy`
- `PD::AssessmentPolicy`
- `PD::PeritonitisEpisodePolicy`
- `PD::PETAdequacyResultPolicy`
- `PD::PETResultPolicy`
- `PD::RegimePolicy`
- `PD::TrainingSessionPolicy`

**Problems (1):**
- `Problems::ProblemPolicy`

**Renal (2):**
- `Renal::AKIAlertPolicy`
- `Renal::RegistryPreflightCheckPolicy`

**Surveys (1):**
- `Surveys::SurveyPolicy`

**System (6):**
- `System::DownloadPolicy`
- `System::MessagePolicy`
- `System::NagDefinitionPolicy`
- `System::OnlineReferenceLinkPolicy`
- `System::UserFeedbackPolicy`
- `System::ViewMetadataPolicy`

**Transplants (8):**
- `Transplants::DonorStagePolicy`
- `Transplants::RecipientFollowupPolicy`
- `Transplants::RecipientOperationPolicy`
- `Transplants::RecipientWorkupPolicy`
- `Transplants::RegistrationPolicy`
- `Transplants::RejectionEpisodePolicy`
- `Transplants::ReviewPolicy`

**Virology (3):**
- `Virology::DashboardPolicy`
- `Virology::ProfilePolicy`
- `Virology::VaccinationPolicy`

**User (1):**
- `UserPolicy`

**Pack Modules (7):**

**Authoring (1):**
- `Authoring::SnippetPolicy`

**Hospitals (1):**
- `Hospitals::WardPolicy`

**Research (5):**
- `Research::ResearchPolicy` (base)
- `Research::StudyPolicy`
- `Research::InvestigatorshipPolicy`
- `Research::ParticipationPolicy`
- `Research::StudyEventPolicy`

---

## Document Information

**Generated:** 2025-10-16
**Source Code Version:** Current main branch
**Total Policies Analyzed:** 105
**Configuration Files:**
- `app/models/renalware/role.rb`
- `app/policies/renalware/base_policy.rb`
- `config/permissions.yml`

**Key Source Files:**
- Role definitions: `app/models/renalware/role.rb:3`
- Base policy: `app/policies/renalware/base_policy.rb`
- Permission configuration: `app/policies/renalware/yaml_permission_configuration.rb`
- YAML restrictions: `config/permissions.yml`

**Maintained By:** Automatically generated from codebase analysis

**Note:** This documentation reflects the authorization logic as implemented in the Pundit policies. Actual behavior may vary based on:
- Configuration flags in the application
- Role enforcement settings in the database
- Time window configurations per event type
- Research study configurations
- Hospital site configurations
