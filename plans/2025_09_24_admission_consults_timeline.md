# Plan: Add Admission Consults to Timeline

**Date**: 2025-09-24

## Overview
Add admission consults to the patient timeline with type "Consult" and using AKI Risk for the description. **Implementation completed using Phlex components following established codebase patterns.**

## Current Timeline Structure Analysis

### Existing Timeline Models
The timeline system currently supports these models (from `/app/services/renalware/patients/timeline.rb:5-12`):
- `Admissions::Admission`
- `Clinics::ClinicVisit`
- `Events::Event`
- `Letters::Letter`
- `Messaging::Internal::Message`
- `Modalities::Modality`

### Timeline Item Pattern
Each timeline item follows this pattern:
1. **Service Class**: Extends `Renalware::TimelineItem` 
    (e.g., `app/services/renalware/admissions/timeline_item.rb`)
2. **Component Class**: For rendering timeline rows 
    (e.g., `app/components/renalware/admissions/timeline_row.rb`)
3. **Registration**: Added to `TIMELINES` constant in `Patients::Timeline`

### Admission Consults Model Analysis
From `/app/models/renalware/admissions/consult.rb:31`:
- **AKI Risk field**: `enumerize :aki_risk, in: %i(yes no unknown)`
- **Required fields**: `patient_id`, `started_on`, `description`
- **Timeline-relevant fields**: `started_on` for sorting
- **Display text**: Available via `aki_risk&.text`

## Implementation Plan

### 1. Create Timeline Service Class
**File**: `app/services/renalware/admissions/consults/timeline_item.rb`
- Extend `Renalware::TimelineItem`
- Implement `scope` method for `Admissions::Consult`
- Add eager loading for related associations (patient, consult_site, hospital_ward)
- **Final class**: `Admissions::Consults::TimelineItem`

### 2. Add ORDER_FIELDS to Consult Model
**File**: `app/models/renalware/admissions/consult.rb`
- Add `ORDER_FIELDS = [:started_on].freeze` constant
- Add `include OrderedScope` for `ordered` scope functionality

### 3. Create Timeline Row Component
**File**: `app/components/renalware/admissions/consults/timeline_row.rb`
- Extend `Renalware::TimelineRow`
- **Final class**: `Admissions::Consults::TimelineRow`
- Implement display logic:
  - **Type**: "Consult"  
  - **Description**: "AKI Risk: " + AKI Risk value (`record.aki_risk&.text`)
  - **Date**: Use `started_on`
  - **Author**: Use `created_by`
- **Detail section**: Uses Phlex `Admissions::Consults::Detail` component

### 4. Register in Timeline System
**File**: `app/services/renalware/patients/timeline.rb`
- Add `Admissions::Consult` to `TIMELINES` constant
- Add custom mapping in `create_timeline_item` method for `Admissions::Consults::TimelineItem`
- Updated timeline component mapping for `Admissions::Consults::TimelineRow`

### 5. Create Tests (TDD Approach)

#### Timeline Item Tests
**File**: `spec/services/renalware/admissions/consults/timeline_item_spec.rb`
- Test item creation and data retrieval
- Verify correct scope usage

#### Timeline Row Component Tests
**File**: `spec/components/renalware/admissions/consults/timeline_row_spec.rb`
- Test type displays as "Consult"
- Test AKI Risk appears in description (with different values: yes/no/unknown/nil)
- Test date and author display
- Test detail section with Phlex component

#### Integration Tests
**File**: `spec/system/renalware/patients/view_timeline_spec.rb`
- Verified consult timeline item appears in patient timeline
- Test consult appears with correct description and toggling functionality

### 6. Create Phlex Detail Component
**File**: `app/components/renalware/admissions/consults/detail.rb`
- **Final class**: `Admissions::Consults::Detail`
- Extends base `Detail` component following established patterns
- Uses `DescriptionListItem` for consistent display format
- Shows: Author, Modality, Description, E-Alert, Specialty, Specialty notes
- Handles presenter wrapping automatically
- **Also updated**: `app/views/renalware/admissions/consults/_table.html.slim` to use 
    same Phlex component

## Key Implementation Details

### AKI Risk Display
- Use `consult.aki_risk&.text` which returns human-readable text ("Yes", "No", "Unknown")
- Handle nil values gracefully with safe navigation operator

### Timeline Sorting
- Consults will be sorted by `started_on` date
- Integrated with existing timeline items chronologically

### Name Service Pattern
The timeline system uses `NameService.from_model(model_class, to: "TimelineItem")` 
to dynamically create the correct timeline item class name. For consults, custom 
mappings were added due to the plural directory structure.

### Phlex Component Architecture
- Follows established codebase patterns using `Detail` base class
- Uses `DescriptionListItem` for consistent field display
- Automatically handles presenter wrapping
- Reused same component in both timeline and main consults table

**Architecture Decision:** Migrated from SLIM partials to Phlex components 
following established codebase patterns.

## Rules
- If stuck, ask for help
