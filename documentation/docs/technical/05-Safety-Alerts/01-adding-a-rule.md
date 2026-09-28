---
slug: "/Safety-Alerts/adding-a-rule"
title: Adding a Safety Alert rule
---

# Adding a Safety Alert rule

This page describes how to add a local Safety Alert rule. The intended audience is a renal
administrator, analyst or consultant with access to a SQL client and enough SQL knowledge to write
and test a PostgreSQL function.

:::caution

Test new rules in a UAT or test environment before enabling them in production. A rule can create
patient-facing clinical alerts.

:::

## 1. Decide the rule purpose

Before writing SQL, decide:

- which patients should be returned
- how often the same patient should be re-alerted after an alert has been resolved
- what short `label` should be shown for each returned row
- what supporting data should be stored in `metadata`
- which category the rule belongs to, for example `General`, `Virology` or `HD`

## 2. Create the SQL function

A Safety Alert rule is a zero-argument PostgreSQL function. Renalware calls it as:

```sql
SELECT * FROM schema_name.function_name();
```

The function must return at least:

| Column | Required | Description |
| --- | --- | --- |
| `patient_id integer` | Yes | The primary key from `renalware.patients.id`. This is not an NHS number or hospital number. |
| `label text` | No, but recommended | A short headline or grouping label for this returned row. |
| `metadata jsonb` | No, but recommended | Supporting row-level details to store with the alert. |

Any extra returned columns are also stored in the alert metadata, except for `patient_id`, `label`
and `metadata`.

### Example function

This example finds HD patients with a positive MSSA screening swab in the last 7 days.

```sql
CREATE OR REPLACE FUNCTION renalware.example_mssa_safety_alert_rule()
RETURNS TABLE(
  patient_id integer,
  label text,
  patient_name text,
  mrn text,
  modality text,
  metadata jsonb
)
LANGUAGE sql
STABLE
AS $$
  SELECT
    p.id AS patient_id,
    'MSSA screen positive'::text AS label,
    p.patient_name,
    p.hospital_numbers AS mrn,
    'HD'::text AS modality,
    jsonb_build_object(
      'observation_id', o.id,
      'observed_at', o.observed_at,
      'result', o.result
    ) AS metadata
  FROM renalware.hd_mdm_patients p
  LEFT JOIN renalware.pathology_observation_requests r
    ON p.id = r.patient_id
  JOIN renalware.pathology_observations o
    ON r.id = o.request_id
  WHERE o.description_id = 306
  AND o.observed_at > current_date - interval '7 days'
  AND o.result NOT ILIKE '%No Staph%';
$$;
```

:::tip

Use `label` flexibly. It can be a clinical headline (`MSSA screen positive`), a priority
(`High Priority`), or a grouping that helps clinicians understand why the patient appeared
(`eGFR < 30`).

:::

## 3. Handle re-alerting in the SQL function

Renalware prevents duplicate active alerts for the same patient/rule combination. However, once a
clinician resolves an alert, the same patient may be returned by the same rule on the next scheduled
run.

Usually you should add SQL to suppress re-alerting for a rule-specific period. This is deliberately
handled in the SQL function because the right period may depend on the rule, label, result value,
modality or other clinical context.

This pattern excludes patients who already have an active alert for this rule, or who had one
resolved in the last month:

```sql
AND NOT EXISTS (
  SELECT 1
  FROM renalware.renal_safety_alerts alerts
  JOIN renalware.renal_safety_alert_rules rules
    ON rules.id = alerts.safety_alert_rule_id
  WHERE alerts.patient_id = p.id
  AND rules.function_name = 'renalware.example_mssa_safety_alert_rule'
  AND (
    alerts.deleted_at IS NULL
    OR alerts.deleted_at > current_timestamp - interval '1 month'
  )
)
```

Adjust the interval for each rule. For some rules, `2 weeks` may be sensible. For others, `2 months`
or a more nuanced condition may be needed.

:::note

Prefer matching the rule by `function_name`, not by rule name. Rule names are user-facing and may be
renamed.

:::

## 4. Create or choose a rule category

Rules must belong to a category. Categories are used for filtering in the admin screens and the
Safety Alerts list.

To create a category manually:

```sql
INSERT INTO renalware.renal_safety_alert_rule_categories (
  name,
  created_at,
  updated_at
)
VALUES (
  'Virology',
  current_timestamp,
  current_timestamp
)
ON CONFLICT (name) DO NOTHING;
```

## 5. Insert the rule row

There is currently no UI for creating new rules. Insert a row manually into
`renalware.renal_safety_alert_rules`.

```sql
INSERT INTO renalware.renal_safety_alert_rules (
  safety_alert_rule_category_id,
  name,
  function_name,
  enabled,
  created_at,
  updated_at
)
VALUES (
  (
    SELECT id
    FROM renalware.renal_safety_alert_rule_categories
    WHERE name = 'Virology'
  ),
  'Positive MSSA screen in last 7 days',
  'renalware.example_mssa_safety_alert_rule',
  false,
  current_timestamp,
  current_timestamp
);
```

Start with `enabled = false`. This allows you to inspect the rule in the Admin UI and run it on
demand before it becomes part of the scheduled overnight run.

## 6. Inspect and test the rule

After inserting the row:

1. Go to Admin menu -> Safety Alert Rules.
2. Filter by category if needed.
3. Expand the rule row to inspect the SQL function definition.
4. Use `Run now` to queue an execution.
5. Review Admin menu -> Safety Rule Executions.
6. Review Renal menu -> Safety Alerts.

Once you are satisfied, enable the rule from Admin menu -> Safety Alert Rules.

## Troubleshooting

### The rule does not appear in the admin list

- Check the row exists in `renalware.renal_safety_alert_rules`.
- Check it has a valid `safety_alert_rule_category_id`.
- Check the user is a super administrator.

### The SQL preview is blank

- Check `function_name` is correct.
- Use a schema-qualified function name, for example `renalware.example_mssa_safety_alert_rule`.
- The function must be zero-argument. The preview intentionally ignores overloaded versions that
  require arguments.

### The execution fails

Look at `renalware.renal_safety_alert_rule_executions.error_message`, or use the Safety Rule
Executions admin page. Common causes are:

- the function does not exist
- the function returns the wrong column type for `patient_id`
- the function returns a `patient_id` that does not exist in `renalware.patients`
- the SQL function raises an error

### The rule returns patients but creates no alerts

This is expected if matching patients already have active alerts for the same rule. Check
`renalware.renal_safety_alerts` for active rows with the same `patient_id` and
`safety_alert_rule_id`.

### The rule keeps re-alerting too soon

Add or tighten the re-alert suppression SQL in the function. See
[Handle re-alerting in the SQL function](#3-handle-re-alerting-in-the-sql-function).
