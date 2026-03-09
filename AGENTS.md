# Repository Guidance

## jQuery Migration Policy

- Treat any touched jQuery-powered code as an opportunity to migrate incrementally toward Stimulus, Turbo, or plain DOM APIs.
- Do not introduce new jQuery usage, new jQuery plugins, or expand the existing jQuery surface area.
- When modifying a file that uses jQuery, prefer replacing the touched behavior in place with Stimulus, Turbo, or plain DOM APIs if the change is local and low risk.
- If full replacement is not safe within the current task, preserve behavior but explicitly note the remaining jQuery dependency and the smallest sensible follow-up step to remove it.
- Prefer incremental vertical-slice migrations over broad rewrites.
- Prioritize replacing simple event handling, DOM toggling, AJAX form flows, and modal lifecycle glue before attempting plugin-heavy or cross-cutting rewrites.
