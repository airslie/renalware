config/letter_sections.yml
==========================

This file contains the configuration for the letters. It is used by the
`Renalware::Letters::Sections` service to add modality specific information to the
letters.

The format is:

```yaml
<environment>:
  <section>:
    - # row
      - label: <label> # field
        path: <path>
        separator: <separator>
      - label: <label>
        path: <path>[:<type>]
        separator: <separator>
```

For example:

```yaml
default:
  hd:
    -
      - label: Plan
        path:
          - accesses_patient.current_plan.plan_type
          - accesses_patient.current_plan.created_at:date
        separator: " "
      - label: Mean post HD BP
        path:
          - hd_patient.rolling_patient_statistics.post_mean_systolic_blood_pressure:integer
          - hd_patient.rolling_patient_statistics.post_mean_diastolic_blood_pressure:integer
        separator: " / "
```
## Environment

This is the Rails environment. Currently, default will be applied to all environments.
This will allow us to add hospital specific configuration if needed in the future
(based on merging the engines)

## Section

Currently, the supported sections are: `hd`, `transplants`, `pd` and `akcc`.
LETTER_SECTIONS_IDENTIFIERS is derived from the letter_sections.yml file and
used to validate the section_identifier in Topic and SectionSnapshot models.

## Row

This is an unnamed array of arrays indicating a row in the letter. It's a way to
group together related values.

## Field

A label and path with an optional separator.

* `label` is the text that will be displayed in the letter
* `path` is an array of one or more paths to the value to display. Path always
    starts with a patient class name (e.g. `hd_patient`). The remaining path
    elements are a chain of methods calls from the patient class.
* `separator` is the text to use between multiple values to join them
* `type` can be used to apply additional formatting to the value. It can be one of:
    * `date` converts the value to a date and formats it with `I18n.l`
    * `duration` - converts the value to a `Renalware::Duration` object
    * `integer` - rounds the value to the nearest integer
    * `percentage` - appends a % to the value
    * a string that will be appended to the value

If `label` is a path, it's looked up the same way as the `path` and allows
dynamic labels. This is currently used for Immunosuppressive where we want to
show 2 different labels depending on which type of immunosuppressive level is shown.

If no `type` is specified, there is some additional inference applied. For
example, DateTime values are formatted with `I18n.l` and booleans are
converted to Yes/No. These conversions are non-exhaustive and additional 
conversions may be needed in the future.
