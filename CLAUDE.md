# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Environment
- `devenv run setup` - Initial setup including database creation and seeding
- `devenv run reset` - Delete PostgreSQL database and re-run setup
- `devenv up` - Start all services (PostgreSQL, Rails server, etc.)

### Testing
- `bin/rspec` - Run RSpec tests
- `bundle exec rake` - Run all tests (RSpec + Cucumber)

### Code Quality
- `bin/rubocop` - Run RuboCop linter with project configuration
- `bin/rubocop -a` - Auto-fix RuboCop safe violations where possible

### JavaScript/Frontend
- `yarn build` - Build JavaScript assets using Rollup
- `yarn build:css` - Build CSS assets (delegated to demo app)

### Database
- `rails db:migrate` - Run database migrations
- `rails db:seed` - Seed database with demo data
- `rails db:reset` - Drop, create, migrate, and seed database

## Architecture Overview

Renalware is a Ruby on Rails engine designed for renal unit management. Key architectural components:

### Engine Structure
- **Core Engine**: `lib/renalware/engine.rb` - Main Rails engine configuration
- **Demo Application**: `demo/` directory contains a standalone Rails app for development
- **Host App Pattern**: Designed to be embedded in host Rails applications via gem

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
- LDAP authentication via `devise_ldap_authenticatable`
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
Uses devenv/Nix for reproducible development environments with process-compose for service orchestration. Local development runs on port 3000 with demo users (superkch, kchdoc, kchnurse, kchguest) using password "renalware".
- You can use demo/db/schema.rb to check the database/model structure

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

### Rules
- Follow existing code style, conventions and patterns
- Add planning documents to plans/ starting with today's date and short description (using lowercase & underscrores)

