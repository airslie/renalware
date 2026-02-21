# Start here (AI + humans)

**Goal:** Give you just enough context to read/modify this code safely.

## Stack
- Renalware-core is a Rails engine. A dummy app lives in ./demo.
- Ruby 3.x, Rails 8, Postgres 16, slim templates, Phlex, ViewComponent, Stimulus, Turbo
- Tests are written in RSpec and use FactoryBot
- There are some cucumber features but we no longer add to these, and are migrating them to
  RSpec slowly

## Run locally
- `bin/setup` then `bin/dev`
- the app will run by default at http://localhost:3000 and start at the login page
- A example demo user is username: superbarts password: renalware

## Where things live

Some non-standard folders:
- app/components - Phlex components
- app/view_components - ViewComponents
- app/services - service objects
- app/forms - form objects
- app/queries - query objects
- app/pdfs/forms - Prawn PDF forms
- app/drops - templates in the Liquid templating language
- app/policies - Pundit policies
- app/values - Value objects

There are number of namespaces used in the app eg Transplants. These correspond to a
clinical concept (eg Admissions), a modality of treatment (eg Transplants),
or a discrete functional area of the app (eg Reporting).

A few of the namespaces have been moved into a `packs` folder as unbuilt engines.
This is an ongoing experiment to see if this will:
- simplify navigating the project
- allow us to use packwerk to track cross-domain calls (packwerk is not fully integrated and
working, possibly because our project is itself and engine and the tooling expects it to be an app.)

## Conventions
- Service objects (in `app/services`)
- Query objects (in `app/queries`)
- Form objects for backing complex HTML forms (in `app/forms`)
- Use Phlex for low level components, and slim for high level views
- Prefer Phlex over ViewComponent for new components
- Prefer Stimulus and Turbo when adding functionality using JavaScript
- Keep Turbo Drive disabled for now
- Run rubocop before pushing a commit
- Avoid ActiveRecord callbacks for business logic
- Avoid cross-domain calls where possible using patterns like eg pub/sub or synchronous plugin
  providers etc

<!--
## High-value entrypoints
- Start with `ai/CODEMAP.md`
- ERD: `docs/erd.png`
- Routes: `docs/ROUTES.md`
-->

## Guardrails
- Try not to make calls across boundaries (eg referencing a class in the PD namespace from the HD
  namespace)
- Migrations must be reversible; use `strong_migrations` safe patterns.

## Roadmap
- Convert project from a Rails engine into a conventional Rails app (requires coordination with
  downstream repos, so is a long term goal to simplify code management and devops)
- Migrate wkhtmltopdf to Prawn for PDF generation
- Enable packwerk
- Remove the Zurb Foundation css/js framework, which is currently used for the grid system etc.
- Remove jquery-ui
- Remove font-awesome and use SVG icons
- Convert SASS to CSS, replacing SASS variables with CSS ones
- Converge on slimselect for dropdowns
