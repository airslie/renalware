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

## Required verification before completion

After making code changes, run both commands from the repository root:

- `bundle exec rubocop`
- `bin/yarn eslint app/javascript --max-warnings=0`

Run both even when only Ruby, JavaScript, or templates changed.
Wait for both commands to finish and inspect their exit statuses.
After fixing lint failures, rerun the affected checks.

Do not weaken lint configuration or add suppressions merely to pass.
Fix violations introduced by the task. Report unrelated existing failures.

The final response must report RuboCop and ESLint separately as:
PASS, FAIL, or NOT RUN, with a reason for any failure or omission.
Do not describe the work as fully verified unless both checks pass.

## Default Codex Workflow

- Inspect existing Rails patterns before editing.
- Implement the smallest safe change that satisfies the request.
- Preserve unrelated behavior and avoid unrelated refactors.
- Do not introduce new jQuery. When touching jQuery-powered behavior, migrate the local slice to Stimulus, Turbo, or plain DOM APIs if low risk.
- Add or update focused tests when the change affects behavior.
- Prioritize authorization, query performance, Turbo/Stimulus regressions, and missing tests.
- Complete the required verification above.
- Summarize the change, verification performed, and any residual risk.
