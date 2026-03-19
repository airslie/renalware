# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Environment
- `devbox run setup` - Initial setup including database creation and seeding
- `devbox run reset` - Delete PostgreSQL database and re-run setup
- `devbox services up` - Start infrastructure services (PostgreSQL)
- `bin/dev` - Start application processes (web server, worker, JS/CSS watchers)

### Testing
- `bin/rspec` - Run RSpec tests
- `bundle exec rake` - Run all tests (RSpec + Cucumber)

### Code Quality
- `bin/rubocop` - Run RuboCop linter with project configuration
- `bin/rubocop -a` - Auto-fix RuboCop safe violations where possible

### JavaScript/Frontend
- `yarn build` - Build JavaScript assets using Rollup
- `yarn build:css` - Build CSS assets

### Database
- `rails db:migrate` - Run database migrations
- `rails db:seed` - Seed database with demo data
- `rails db:reset` - Drop, create, migrate, and seed database

## Architecture Overview

Renalware is a Ruby on Rails application for renal unit management. Key architectural components:

### Application Structure
- **Main Application**: `config/application.rb` and `config/routes.rb` define the Rails app
- **Pack Engines**: `packs/*/lib/**/engine.rb` contain modular domain packs mounted by the app
- **Single App Runtime**: local development and deployment run this application directly

### Domain Organization
The application is organized into medical/clinical domains under `app/models/renalware/`:
- `admissions/` - Patient admission management
- `hd/` (hemodialysis) - Dialysis session management and scheduling
- `drugs/` - Medication management
- `monitoring/` - Patient monitoring and data ingestion
- `pathology/` - Lab results and pathology data
- `letters/` - Clinical correspondence and FHIR integration

### Key Technologies
- Rails 8.0+ with PostgreSQL database
- Authentication via Devise with OmniAuth strategies for LDAP and Entra ID
- Background jobs with Good Job
- Frontend: Stimulus, Turbo, Rollup for JS bundling
- Testing: RSpec with Playwright driver
- Code quality: RuboCop with custom configuration
- UI
  - Forms: Slim templates
  - Legacy: Slim templates, ViewComponents (deprecated)
  - New: Phlex except for forms
  - Styling: Tailwind CSS (Foundation is deprecated)

### Data Integration
- HL7 message processing for clinical data ingestion
- FHIR STU3 models for healthcare data exchange
- Pathology result ingestion from external systems

### Development Environment
Uses Devbox/Nix for reproducible development environments. Infrastructure services (PostgreSQL) are managed via `devbox services up`, while application processes are managed by Foreman via `bin/dev` (see `Procfile.dev`). Local development runs on port 3000 with demo users (superkch, kchdoc, kchnurse, kchguest) using password "renalware".
- Use `db/schema.rb` to inspect the database/model structure

### Testing

- You are a TDD expert. Use TDD principles for all code generation
  1. Write tests for features that do not exist yet
  2. Run tests to ensure they fail as expected
  3. Write the minimum amount of code to make the tests pass
  4. Repeat steps 2 and 3 until all tests pass. Do not modify tests during this phase
  5. Refactor the code to make it more readable and maintainable while keeping the tests passing
  6. Commit the tests and code
- NEVER add code into models that's needed by specs or factories. Tests should depend on code. Not the other way round.
- Don't use allow_any_instance_of
- Don't write controller tests. System tests are better
- Don't write Cucumber features. These are deprecated
- Use descriptive test names that document behavior
- Avoid code comments, tests and well named methods are the documentation

### Coverage Reporting
SimpleCov is configured to track code coverage for both RSpec and Cucumber tests:
- **CI/CD**: Coverage is automatically collected and uploaded to Codecov
- **Reports**: Coverage reports are available at `coverage/index.html` after running tests

### Rules
- Follow existing code style, conventions and patterns
- Add planning documents to plans/ starting with today's date and short description (using lowercase & underscrores)
