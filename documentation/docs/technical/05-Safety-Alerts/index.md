---
slug: "/Safety-Alerts/"
title: Safety Alerts
---

# Safety Alerts

Safety Alerts are a rules-based alerting system for drawing clinicians' attention to renal
patients who may need review. They are designed for rules that can be expressed in SQL, such as
"HD patients with a positive MSSA screening swab in the last 7 days".

Safety Alert rules are maintained locally by renal administrators. A rule is a PostgreSQL function
that returns the patients who should have an alert. Renalware runs enabled rules on a schedule,
records each execution, and creates alerts for returned patients.

## Key concepts

| Item | Description |
| --- | --- |
| Safety Alert Rule | A database row pointing to a SQL function. Rules have a name, category, function name and enabled flag. |
| Safety Alert Rule Category | A simple grouping for rules, such as `General`, `Virology` or `HD`. Categories are used for filtering rules, executions and alerts. |
| Safety Alert | The patient-facing alert created when a rule returns a patient. Alerts appear under the Renal menu. |
| Label | A short piece of text returned by the SQL function for each patient row. Use it as a flexible headline or grouping label, for example `High Priority`, `Low Priority`, `eGFR > 30` or `MSSA screen positive`. |
| Execution | An audit record showing when a rule ran, whether it succeeded, how many rows it matched, and how many new alerts were created. |

## How alerts are created

1. Renalware runs enabled Safety Alert rules on a cron schedule.
2. Each rule calls its configured zero-argument PostgreSQL function.
3. The function returns rows containing at least a `patient_id`.
4. Renalware creates one active alert per patient/rule combination.
5. If the patient already has an active alert for that rule, no duplicate active alert is created.
6. The execution record is updated with status, matched count and created count.

Clinicians can resolve an alert from the Safety Alerts page. Resolving an alert sets `deleted_at`
and moves it from the Active tab to the Historical tab. Notes may be added before resolving, or as
part of resolving the alert.

## Where to view alerts and rules

Clinicians view alerts from:

- Renal menu -> Safety Alerts
- Active tab: current unresolved alerts
- Historical tab: resolved alerts

Super administrators can view rule configuration from:

- Admin menu -> Safety Alert Rules
- Admin menu -> Safety Rule Executions

Rules can be enabled, disabled and queued to run from the Safety Alert Rules admin page. Creating a
new rule still requires manually inserting a row into the database.

## Database tables

The main tables are:

| Table | Purpose |
| --- | --- |
| `renalware.renal_safety_alert_rule_categories` | Rule categories used for grouping and filtering. |
| `renalware.renal_safety_alert_rules` | Rule definitions. Each row points to a SQL function. |
| `renalware.renal_safety_alert_rule_executions` | Audit trail for scheduled and manually queued rule runs. |
| `renalware.renal_safety_alerts` | Alerts created for patients. Active alerts have `deleted_at IS NULL`; resolved alerts have `deleted_at` populated. |

See [Adding a Safety Alert rule](./01-adding-a-rule.md) for the recommended workflow.
