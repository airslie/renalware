# Renalware Form Model Pattern (Pilot)

This describes the pilot approach for building forms without SimpleForm wrappers.

## Goals

- Keep rendered HTML explicit and easy to reason about.
- Avoid wrapper DSL magic and hidden side effects.
- Use Tailwind-backed classes with a small, stable surface area.
- Migrate one form at a time with low risk.

## Core Pattern

- Use `form_with` with a thin builder: `Renalware::FormBuilders::Horizontal`.
- Keep builder methods small and predictable.
- Use explicit template markup for unusual cases.

Example:

```slim
= form_with model: attachment,
            builder: Renalware::FormBuilders::Horizontal,
            html: { class: "rw-form" } do |f|
  = f.error_summary
  = f.date_row :document_date
  = f.text_row :name
  = f.text_area_row :description

  = f.actions_row do
    = link_to t("btn.cancel"), patient_attachments_path(attachment.patient), class: "btn btn-secondary"
    = f.submit nil, class: "btn btn-primary"
```

## Builder API (Pilot Scope)

- `error_summary`
- `field_row`
- `text_row`
- `date_row`
- `text_area_row`
- `select_row`
- `file_row`
- `actions_row`

Field sizing is controlled via a semantic `size:` option:

- `:xs`
- `:sm`
- `:md`
- `:lg`
- `:full`
- `:date` (used by default in `date_row`)

Example:

```slim
= f.date_row :document_date          / defaults to size: :date
= f.text_row :name, size: :sm
```

If a form needs behavior that does not fit these methods cleanly, prefer explicit view markup first.

## CSS Contract (Pilot Scope)

- `.rw-form`
- `.rw-field-row`
- `.rw-label`, `.rw-label__text`
- `.rw-control`
- `.rw-input`
- `.rw-hint`
- `.rw-error`
- `.rw-actions`
- `.rw-error-summary`

These classes are defined in `app/assets/stylesheets/components/forms.css`.

## Migration Guidelines

- Do not alter global SimpleForm behavior as part of this pilot.
- Convert one form end-to-end before attempting broader reuse.
- Validate parity for submission flow, errors, and JS data attributes.
- Capture lessons learned before migrating a second form.
