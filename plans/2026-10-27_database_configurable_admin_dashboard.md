# Database-configurable dashboards: phase 1 (global admin dashboard)

## Goal

Replace the three hard-coded components on the admin dashboard
(`UserActivityComponent`, `IntegrationActivityComponent`, `UsersAwaitingApprovalComponent`)
with a dashboard defined in the database:

- widgets (the view components) are registered in the DB, each with the roles allowed to see it
- a global `admin` dashboard lists them in a configurable order
- the page renders only the components the current user is permitted to see

Out of scope for phase 1: per-user dashboards, UI for editing dashboards, dashboard-level roles,
migrating the legacy home dashboard (`dashboard/dashboards/_content.html.slim`).

## Decisions (agreed)

- `super_admin` can see everything `admin` can. Implemented by listing both roles explicitly on
  each component (no implicit hierarchy in code), guarded by a spec.
- A component with no roles is visible to nobody (fail closed).
- Dashboards do not have roles yet. The route-level policy (`authorize User, :index?`) stays.
- Components that depend on config (e.g. Mesh) hide themselves via ViewComponent's existing
  `render?` hook (already used by other components). No separate `enabled?` concept. DB rows are
  not toggled by config.
- `devops` can see the three admin widgets, so rows are seeded for admin, super_admin and devops.
- Per-placement layout lives in `settings jsonb` on `system_dashboard_placements`. Any stored
  classes are Tailwind utility classes (or custom Tailwind classes), never Foundation.
- Keep the `system_` table prefix (consistent with `system_view_metadata`). `system_components` is renamed to `system_dashboard_widgets` for clarity; "widget" is the DB-registered thing, "component" remains the Ruby view component class.

## Schema changes (new forward migration, tables are empty and unused)

### system_components -> renamed to system_dashboard_widgets
- `rename_table :system_components, :system_dashboard_widgets` (rename its indexes and table comment too)
- add `key` string, null: false, unique, immutable. Stable identifier, e.g. `user_activity`
- keep `name` (display), `class_name`
- make `class_name` unique
- drop `roles` string column and its index
- drop `dashboard` boolean (unused intent; re-add as `selectable` if needed in phase 2)
- add `description` text

### system_dashboard_widget_roles (new)
- `widget_id` FK to system_dashboard_widgets, null: false, on_delete cascade
- `role_id` FK to roles, null: false, on_delete cascade (integer to match `roles.id` serial)
- unique index on `[widget_id, role_id]`, index on `role_id`

### system_dashboards
- add `key` string (slug), null: false
- unique index on `key` where `user_id IS NULL` (replaces unique `name` index)
- drop unique index on `user_id`; add FK to users (on_delete cascade)
- unique index on `[user_id, cloned_from_dashboard_id]` where `user_id IS NOT NULL`
- `cloned_from_dashboard_id` FK: on_delete nullify
- fix column comment typo

### system_dashboard_components -> renamed to system_dashboard_placements
- `rename_table :system_dashboard_components, :system_dashboard_placements` (rename its indexes, FKs and table comment too; update comment to "A widget placed on a dashboard")
- rename `component_id` to `widget_id` (FK to system_dashboard_widgets)
- `dashboard_id` and `widget_id` null: false
- `dashboard_id` FK on_delete cascade; `widget_id` FK on_delete restrict
- drop unique `[dashboard_id, position]`; replace with non-unique index. Default position removed
  (null: false, no default) and ordering is `position, id`
- add `settings` jsonb, null: false, default `{}` (e.g. `{"wrapper_classes": "lg:col-span-2"}`)
- keep unique `[dashboard_id, widget_id]` for phase 1

Update both `db/schema.rb` and `db/structure.sql`.

## Code

- Models under `Renalware::System`: `DashboardWidget`, `DashboardWidgetRole`, `Dashboard`, `DashboardPlacement` (a widget placed on a dashboard)
  - `DashboardWidget.visible_to(user)`: joins `system_dashboard_widget_roles` to the user's role ids, distinct
  - `Dashboard#widgets_for(user)`: ordered by `position, id`, filtered by `visible_to`
  - `DashboardWidget` validates `class_name` is in the registry
- `System::Dashboards::WidgetRegistry`: allowlist mapping `key` to class. Never `constantize`
  a DB value that is not in the registry
- Component contract: `new(current_user:, wrapper_classes:)`; components may define `render?`
  (ViewComponent standard) to hide themselves. Remove Foundation default `wrapper_classes` from the
  three components
- Renderer (Slim partial or helper, not Phlex): loops visible rows, relies on `render?` for self-hiding, rescues
  and logs a missing registry entry rather than 500ing the page, applies `settings["wrapper_classes"]`
  to the wrapper
- `Admin::DashboardsController#show` loads `Dashboard.find_by!(key: "admin")`; view renders it
- Components not permitted for the user must never be instantiated or have their queries run

## Seeding

Seeds are NOT re-run on deploy, so the initial rows are created by a **data migration**
(idempotent: `find_or_create_by` on keys, safe to re-run, uses lightweight migration-local models
rather than app models). Roles are looked up by name and the migration fails loudly if a role row
is missing. The same rows are also added to `db/seeds/default/system/` for fresh installs; both
call one shared definition if practical, otherwise the seed is the duplicate.

| key | class | roles |
|---|---|---|
| user_activity | System::UserActivityComponent | admin, super_admin, devops |
| integration_activity | Monitoring::Mirth::IntegrationActivityComponent | admin, super_admin, devops |
| users_awaiting_approval | System::UsersAwaitingApprovalComponent | admin, super_admin, devops |

Admin dashboard (`key: admin`) positions 10, 20, 30 with `lg:col-span-1 min-w-0` style wrapper
classes matching today's grid.

## Test plan (TDD, system specs not controller specs)

- model specs: `DashboardWidget.visible_to` (role match, multiple roles, no roles => hidden),
  dashboard ordering, registry validation, uniqueness/constraints
- system specs for the admin dashboard: admin sees the configured set; super_admin sees the same;
  a component with only `super_admin` is hidden from admin; reordering positions changes DOM order;
  unregistered/removed class is skipped without error
- spec that every seeded admin-visible component also lists `super_admin` and `devops`
- Specs use factories, so tests create their own widget, role-link, dashboard and placement rows
  first (factories for `DashboardWidget`, `Dashboard`, `DashboardPlacement`; no reliance on seeds).
  The existing `spec/system/renalware/admin/dashboard_spec.rb` is extended to build the admin
  dashboard through these factories before visiting the page
- Data migration spec (or a manual check on a copy of the DB): running it twice creates the three
  widgets, their role links and the placements once only
- spec that a hidden component's query is not executed

## Checks before/while implementing

- `db/structure.sql` is the source of truth (`schema_format = :sql`); regenerate it with the
  migration. Only touch `db/schema.rb` if the project still tracks it
- Migration uses `within_renalware_schema`
- `visible_to(user)` queries role ids with a single join, not the memoized `User#role_names`
- Confirm the three component namespaces autoload cleanly via the registry
- Tailwind purges classes that only appear in the DB: the classes used by the seeded
  `wrapper_classes` must appear in scanned source (e.g. the migration/seed file, or a safelist).
  Verify the built CSS contains them
- Compare rendered admin dashboard HTML/layout before and after

## Open items for later phases

- Dashboard-level roles and a policy
- Per-user clones (`cloned_from_dashboard_id`), editing UI, validation of client-supplied ids
- Legacy home dashboard migration and its config-conditional components (Mesh) via `render?`
- Cache keys that vary by role if any component output ever differs by viewer

## Implementation notes (deviations from the plan above)

- The old `System::Component`, `Dashboard`, `DashboardComponent` models and specs already existed;
  they were replaced by `DashboardWidget`, `DashboardWidgetRole`, `DashboardPlacement` and an
  updated `Dashboard`
- `ComponentRegistry` is an allowlist of class names (not key => class); `DashboardWidget#class_name`
  must be in it
- The data migration skips roles that do not exist (fresh databases get roles from seeds) rather than
  failing; `db/seeds/default/system/dashboards.rb` adds the same rows for fresh installs
- `Admin::DashboardsController` renders an empty grid if the `admin` dashboard row is missing, so
  other admin specs and deploys without the data do not 500
- `min-w-0` added to the Tailwind safelist because it is stored only in the database
- Component `wrapper_classes` defaults were left as they are (the legacy home dashboard still uses
  `UsersAwaitingApprovalComponent`'s default); the renderer always passes the placement's classes
