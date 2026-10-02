# Repository Guidance

## UI Rendering Policy

- Do not create new Phlex components or convert existing views to Phlex.
- Use Slim templates and partials for new UI, following existing Rails patterns.
- Existing Phlex components may be maintained when required by the task; do not introduce new Phlex components as part of that work.

## jQuery Migration Policy

- Treat any touched jQuery-powered code as an opportunity to migrate incrementally toward Stimulus, Turbo, or plain DOM APIs.
- Do not introduce new jQuery usage, new jQuery plugins, or expand the existing jQuery surface area.
- When modifying a file that uses jQuery, prefer replacing the touched behavior in place with Stimulus, Turbo, or plain DOM APIs if the change is local and low risk.
- If full replacement is not safe within the current task, preserve behavior but explicitly note the remaining jQuery dependency and the smallest sensible follow-up step to remove it.
- Prefer incremental vertical-slice migrations over broad rewrites.
- Prioritize replacing simple event handling, DOM toggling, AJAX form flows, and modal lifecycle glue before attempting plugin-heavy or cross-cutting rewrites.

## Verification

- After making code changes, run `bundle exec rubocop` on the touched files where feasible.
- Fix any RuboCop offenses introduced by the change before finishing.
- If RuboCop cannot be run or a clean result is blocked by pre-existing offenses outside the change, report that clearly in the final response.

## Default Codex Workflow

- Inspect existing Rails patterns before editing.
- Implement the smallest safe change that satisfies the request.
- Preserve unrelated behavior and avoid unrelated refactors.
- Do not introduce new jQuery. When touching jQuery-powered behavior, migrate the local slice to Stimulus, Turbo, or plain DOM APIs if low risk.
- Add or update focused tests when the change affects behavior.
- Prioritize authorization, query performance, Turbo/Stimulus regressions, and missing tests.
- Run RuboCop on touched files where feasible and fix offenses introduced by the change.
- Summarize the change, verification performed, and any residual risk.
