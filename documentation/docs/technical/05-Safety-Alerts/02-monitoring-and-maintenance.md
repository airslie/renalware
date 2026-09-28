---
slug: "/Safety-Alerts/monitoring-and-maintenance"
title: Monitoring and maintenance
---

# Monitoring and maintenance

Safety Alert rules should be monitored after they are introduced, especially during the first few
scheduled runs.

## Monitoring executions

Executions can be viewed from:

- Admin menu -> Safety Rule Executions

The page lists executions in reverse chronological order and can be filtered by rule category or
rule.

The underlying table is `renalware.renal_safety_alert_rule_executions`.

| Column | Meaning |
| --- | --- |
| `safety_alert_rule_id` | The rule that was run. |
| `started_at` | When the rule started. |
| `finished_at` | When the rule finished. |
| `status` | `succeeded` or `failed`. |
| `matched_count` | Number of rows returned by the SQL function. |
| `created_count` | Number of new alerts created. This may be lower than `matched_count` if some patients already had active alerts. |
| `duration_ms` | How long the rule took to run. |
| `error_message` | Failure detail if the execution failed. |

## Checking recent executions in SQL

```sql
SELECT
  executions.id,
  categories.name AS category,
  rules.name AS rule_name,
  executions.status,
  executions.started_at,
  executions.finished_at,
  executions.matched_count,
  executions.created_count,
  executions.duration_ms,
  executions.error_message
FROM renalware.renal_safety_alert_rule_executions executions
JOIN renalware.renal_safety_alert_rules rules
  ON rules.id = executions.safety_alert_rule_id
JOIN renalware.renal_safety_alert_rule_categories categories
  ON categories.id = rules.safety_alert_rule_category_id
ORDER BY executions.started_at DESC
LIMIT 50;
```

## Understanding matched count and created count

`matched_count` is the number of rows returned by the SQL function.

`created_count` is the number of new active alerts created. It can be lower than `matched_count`
when:

- a patient already has an active alert for the same rule
- another execution created the same alert concurrently

If `matched_count` is unexpectedly high, review the SQL function before enabling the rule.

## Enabling and disabling rules

Rules can be enabled or disabled from:

- Admin menu -> Safety Alert Rules

Disabled rules do not run as part of the scheduled batch. They can still be queued manually with
`Run now`, which is useful for testing.

You can also update a rule directly in SQL:

```sql
UPDATE renalware.renal_safety_alert_rules
SET enabled = false,
    updated_at = current_timestamp
WHERE function_name = 'renalware.example_mssa_safety_alert_rule';
```

## Reviewing generated alerts

Alerts can be reviewed from:

- Renal menu -> Safety Alerts

Use the Active tab for unresolved alerts and the Historical tab for resolved alerts. Both tabs can
be filtered by rule category or rule.

The underlying table is `renalware.renal_safety_alerts`.

| Column | Meaning |
| --- | --- |
| `patient_id` | Patient with the alert. |
| `safety_alert_rule_id` | Rule that created the alert. |
| `safety_alert_rule_execution_id` | Execution that created the alert, if available. |
| `rule_name` | Snapshot of the rule name when the alert was created. |
| `label` | Short label returned by the SQL function. |
| `metadata` | Supporting details returned by the SQL function. |
| `deleted_at` | Populated when the alert is resolved. |
| `deleted_by_id` | User who resolved the alert. |
| `notes` | Clinician notes. |

## Safe rollout checklist

Before enabling a new rule:

- Test the SQL function directly in a SQL client.
- Check the function returns a sensible number of rows.
- Check every returned `patient_id` exists in `renalware.patients`.
- Include re-alert suppression if repeat alerts should be delayed after resolution.
- Insert the rule with `enabled = false`.
- Queue a manual execution from Admin menu -> Safety Alert Rules.
- Review the execution status and counts.
- Review the generated alerts.
- Enable the rule only after the output has been checked.
