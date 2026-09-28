---
slug: "/Reporting/custom-widgets"
title: Custom SQL view widgets
---

Custom SQL view widgets let a hospital surface local SQL-view data inside a
Renalware dashboard or summary page without adding a Renalware model for that
data.

They are intended for compact, read-only tables. They are deliberately simpler
than reports: there is no filtering, charting, CSV export or pagination. They do
reuse the same column metadata and table rendering behaviour as SQL-backed
reports, so column labels, widths, truncation and patient links work in the same
way.

If users need to explore a larger data set, create a normal report instead.

## Lab pages

The first supported user-facing surface for widgets is the hidden **Lab** area:

```text
/lab
/patients/:patient_id/lab
```

These pages are URL-only; they are not linked from navigation. Access is guarded
by the per-user `Renalware::FeatureFlags::LAB` feature flag. Superadmins do not
bypass this feature flag.

Lab widgets are deliberately constrained:

- the SQL view must be in the `site` schema
- only widgets configured for the Lab slots are rendered
- patient Lab widgets must define `widget_options.patient_id_column`
- global Lab widgets that return patient rows are filtered through the current
  user's patient policy scope
- SQL execution uses the widget query timeout and read-only transaction guard

The built-in Lab slots are:

```text
lab:global:top
lab:global:middle
lab:global:bottom
lab:patient:top
lab:patient:middle
lab:patient:bottom
```

The `site` schema is intended for hospital-owned SQL views. It is not specific to
Lab, and may also contain future production SQL views.

## How it works

A custom widget has three parts:

1. A SQL view in Postgres.
2. A `renalware.system_view_metadata` row with `category = 'widget'`.
3. A named widget slot in a Renalware view, for example `lab:patient:middle`.

At render time Renalware finds all widget metadata rows whose `widget_options`
include the slot name, queries each SQL view, and renders the result in an
`<article>` table.

## Create the SQL view

Create the SQL view in the `site` schema for Lab widgets. The view can be
global, or it can be scoped to a patient.

For a patient-scoped widget, the SQL view must return a patient id column. The
column name is configurable, but `patient_id` is recommended.

Example:

```sql
CREATE OR REPLACE VIEW site.ukm_adequacy_widget AS
SELECT
  patient_id,
  performed_on,
  test_type
FROM renalware_kch.ukm_adequacy_results;
```

## Add widget metadata

Add a row to `renalware.system_view_metadata`.

```sql
INSERT INTO renalware.system_view_metadata
(
  schema_name,
  view_name,
  category,
  title,
  columns,
  widget_options,
  position,
  created_at,
  updated_at
)
VALUES
(
  'site',
  'ukm_adequacy_widget',
  'widget',
  'UKM adequacy',
  '[
    { "code": "patient_id", "hidden": true },
    { "code": "performed_on", "name": "Date", "width": "date" },
    { "code": "test_type", "name": "Type" }
  ]',
  '{
    "slots": ["lab:patient:middle"],
    "max_rows": 5,
    "patient_id_column": "patient_id",
    "order_by": "performed_on",
    "order_direction": "desc",
    "empty_state": "No UKM adequacy data"
  }',
  1,
  current_timestamp,
  current_timestamp
);
```

## Widget options

`widget_options` is JSON stored on the metadata row.

| Option | Required | Description |
| --- | --- | --- |
| `slots` | Yes | Array of named page slots where the widget should render. |
| `max_rows` | No | Maximum rows to display. Defaults to `5`. Maximum is `100`. |
| `patient_id_column` | No | Column used to scope rows to the current patient. Omit for global widgets. |
| `order_by` | No | SQL view column used for ordering. |
| `order_direction` | No | `asc` or `desc`. Defaults to `desc`. |
| `empty_state` | No | Text shown when the widget has no rows. |
| `async` | No | When `true`, Lab pages load the widget in a lazy Turbo frame. Defaults to `false`. |

If `patient_id_column` is present, Renalware will only show rows for the patient
passed to the widget slot. If the slot is rendered without a patient, Renalware
shows the empty state rather than returning unscoped rows.

For async Lab widgets, patient context is derived from the slot name. Any
colon-delimited `patient` segment marks the slot as patient-context, for example:

```text
lab:patient:middle
dashboard:patient:middle
patient:summary
```

Patient-context async widgets must be requested with a patient id. The async
endpoint derives the patient scoping server-side rather than trusting a client
parameter.

## Async loading

Lab widgets can opt into lazy loading:

```json
{
  "slots": ["lab:patient:middle"],
  "max_rows": 5,
  "patient_id_column": "patient_id",
  "async": true
}
```

When `async` is `true`, the Lab page first renders a lightweight loading
placeholder and a `turbo-frame`. Turbo then requests the widget content from:

```text
/system/sql_view_widgets/:id
```

The endpoint still checks the Lab feature flag, validates that the requested
schema and slot match the widget metadata, and reuses the normal widget renderer.
This means errors, patient scoping, SQL timeouts and `ViewCall` auditing behave
the same as synchronously-rendered widgets.

## Column definitions

Widgets reuse the existing `system_view_metadata.columns` format used by reports.

Useful column options are:

| Option | Description |
| --- | --- |
| `code` | SQL view column name. |
| `name` | Display label. Falls back to a humanized column name. |
| `hidden` | Hide the column from the widget. Useful for `patient_id`. |
| `width` | Optional width hint, such as `tiny`, `small`, `medium`, `large`, `date`, `datetime`, `nhs_number`, `hospital_numbers` or `patient_name`. |
| `truncate` | Whether to truncate long cell content. |

Columns not listed in metadata are still displayed unless hidden. Put columns in
the metadata array to control the display order.

Widgets also reuse report-style cell rendering:

- date and datetime values are localized
- boolean values render as checked or unchecked icons
- rows with a `secure_id` column and a `patient` or `patient_name` column render
  the patient cell as a link
- common column names such as `performed_on`, `performed_at`, `nhs_number`, `age`,
  `sex` and `patient_name` get sensible default width classes

## Configure columns

Superadmins can configure widget columns from each rendered widget using the
**Configure columns** action. This opens the existing `system_view_metadata`
modal used by reports.

The action is only shown when the current user is authorized by
`Renalware::System::ViewMetadataPolicy#edit?`. Non-superadmin users can view the
widget, but cannot configure columns.

## Add a slot to a page

Render a slot from any Slim view:

```slim
= sql_view_widgets_for("lab:patient:middle", patient: patient)
```

For a global widget, omit the patient:

```slim
= sql_view_widgets_for("lab:global:top")
```

For Lab pages, pass the Lab-specific options used by the built-in Lab views:

```slim
= sql_view_widgets_for(
  "lab:patient:middle",
  patient: patient,
  lab: true,
  schema_name: "site",
  require_patient_scope: true
)
```

The slot name is a convention, but patient-context slots should include `patient`
as a colon-delimited segment. Use names that identify the page and the region,
for example:

```text
lab:patient:middle
lab:global:top
dashboard:patient:middle
patient:summary
user:dashboard
```

## Example Lab widget

```sql
INSERT INTO renalware.system_view_metadata
(
  schema_name,
  view_name,
  category,
  title,
  columns,
  widget_options,
  position,
  created_at,
  updated_at
)
VALUES
(
  'site',
  'ukm_adequacy_widget',
  'widget',
  'UKM adequacy',
  '[
    { "code": "patient_id", "hidden": true },
    { "code": "performed_on", "name": "Date", "width": "date" },
    { "code": "test_type", "name": "Type" }
  ]',
  '{
    "slots": ["lab:patient:middle"],
    "max_rows": 5,
    "patient_id_column": "patient_id",
    "order_by": "performed_on",
    "order_direction": "desc",
    "empty_state": "No UKM adequacy data",
    "async": true
  }',
  1,
  current_timestamp,
  current_timestamp
);
```

## Limitations

- Widgets are read-only.
- Widgets do not paginate.
- Widgets do not support report filters.
- Widgets do not currently link to a full report automatically.
- SQL view, order and patient-scope columns must be real columns in the view.
- Patient-scoped widgets depend on the SQL view returning the configured patient
  id column.
- Async rendering is currently wired for Lab widgets.
