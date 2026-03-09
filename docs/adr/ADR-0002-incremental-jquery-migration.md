# ADR-0002: Touched jQuery functionality should migrate incrementally to Stimulus/Turbo

- Status: Accepted
- Date: 2026-03-09
- Decision makers: Renalware core team

## Context

Renalware currently runs two front-end approaches in parallel:
- a legacy Sprockets stack with `jquery`, Foundation 5, Select2, jQuery UI, and `.js.erb`
- a modern stack based on Stimulus and Turbo

This mixed state is workable, but it creates drag:
- new features can accidentally deepen the legacy jQuery surface area
- simple UI changes often preserve old patterns rather than moving them toward the modern stack
- broad rewrites would be risky and slow

We need a migration policy that reduces jQuery over time without requiring large cross-cutting changes.

## Decision

For any new front-end behavior:
- Do not introduce new jQuery usage or new jQuery plugin dependencies.
- Prefer Stimulus, Turbo, or plain DOM APIs.

For existing jQuery-powered behavior:
- When a piece of jQuery functionality is touched for feature work, bug fixing, or refactoring, prefer replacing the touched behavior in place with Stimulus, Turbo, or plain DOM APIs when the change is local and low risk.
- If a full replacement is not safe within the current task, preserve behavior but document the remaining jQuery dependency and the smallest sensible follow-up step.
- Prefer incremental vertical-slice migrations over broad rewrites.

Migration priority should generally be:
- simple event handling and DOM toggling
- AJAX form flows and modal lifecycle glue
- server-rendered `.js.erb` responses
- plugin-heavy areas such as Foundation Reveal, Select2, date/time pickers, nested forms, and jQuery UI

## Consequences

Positive:
- jQuery usage should shrink steadily as normal work happens.
- New code will align with the existing Stimulus/Turbo direction.
- Risk is controlled by keeping migrations local to the behavior being changed.

Trade-offs:
- Legacy and modern patterns will coexist for a period of time.
- Some tasks will still need to preserve jQuery temporarily because of plugin or response-format dependencies.

## Implementation Notes

- Agent-facing guidance for this policy lives in the repository `AGENTS.md`.
- This ADR is guidance for contributors and reviewers: touched jQuery should be treated as a migration opportunity, not as a reason to extend the legacy pattern.
- Avoid "gunshot surgery": replace one behavior or one dependency seam at a time.

## Follow-up

- Add reviewer guidance to call out new jQuery usage in changed files.
- Consider lightweight checks to flag new uses of `$(`, `jQuery`, or legacy plugin initialization outside approved legacy areas.
- Track migrations by dependency seam, especially Foundation Reveal, Select2, `.js.erb`, nested forms, and jQuery UI.
