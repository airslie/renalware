# ADR-0001: New HTML forms use `form_with` + `Renalware::FormBuilders::Horizontal`

- Status: Accepted
- Date: 2026-02-27
- Decision makers: Renalware core team

## Context

Renalware has many forms implemented using `simple_form` and complex wrapper configuration.
That wrapper approach has become hard to reason about and expensive to evolve while migrating
away from Foundation CSS.

We need a modern form pattern that:
- is explicit in templates
- is Tailwind-first
- avoids a "black box" wrapper API
- can be adopted incrementally without breaking legacy pages

## Decision

For all new or substantially rewritten HTML forms:
- Use Rails `form_with`.
- Use `Renalware::FormBuilders::Horizontal` for shared row helpers and conventions.
- Use Tailwind-oriented classes/patterns from the builder and component CSS.

For existing forms:
- `simple_form` remains supported as a legacy path during migration.
- Do not introduce new `simple_form_for`/`simple_form_with` usage.
- Migrate legacy forms opportunistically when touching a form for feature work.

## Consequences

Positive:
- New forms are easier to read and change.
- Tailwind migration is unblocked without broad wrapper rewrites.
- Form behaviour and styling are centralized in a Ruby builder + component CSS.

Trade-offs:
- Two patterns (`simple_form` and `form_with`) will coexist during transition.
- Some duplication may remain until legacy forms are migrated.

## Implementation Notes

- Pilot form reference: patient attachments form.
- Builder location: `lib/renalware/form_builders/horizontal.rb`.
- Component styling: `app/assets/stylesheets/components/forms.css`.
- Flatpickr/date behaviour should be implemented through builder helpers, not ad hoc view code.

## Follow-up

- Add CI checks to block new `simple_form_for` and `simple_form_with` in changed files.
- Add/update contributor and agent-facing guidance to point to this ADR.
