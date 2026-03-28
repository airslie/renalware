# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to
improve patient care, undertake clinical and administrative audits and share
data with external systems.

## Technical Overview

`renalware-core` is an open-source Ruby on Rails application for renal unit
management.

Renalware is built using open source projects including:
- Ruby on Rails framework
- PostgreSQL database

## Running Renalware locally on Mac, Windows or Linux

The supported local workflow is a native setup
with Ruby, Node.js, Yarn, and PostgreSQL installed on your machine.

### Prerequisites

- Ruby `3.4.8` (see [`.ruby-version`](/Users/tim/Code/airslie/renalware/core/.ruby-version))
- Node.js `22.x`
- Yarn `1.x`
- PostgreSQL `16.x`
- Microsoft core fonts for PDF generation

Install the Microsoft core fonts if they are not already present:

- On Ubuntu: `sudo apt install ttf-mscorefonts-installer`
- On NixOS: add the package `corefonts` to your `configuration.nix`

### Configure PostgreSQL

Renalware expects a local PostgreSQL role named `renalware` with password
`renalware` unless you override `POSTGRES_USER` and `POSTGRES_PASSWORD`.

```bash
createuser --superuser renalware
psql -d postgres -c "ALTER USER renalware WITH PASSWORD 'renalware';"
```

### Bootstrap the application

```bash
git clone git@github.com:airslie/renalware-core.git
cd renalware-core
bundle install
yarn install
bin/rails db:create db:migrate
bin/dev
```

If you prefer to use the project bootstrap script, run `bin/setup` after the
PostgreSQL role is in place. It installs dependencies, prepares the database,
builds assets, and starts `bin/dev`.

Visit [http://localhost:3000](http://localhost:3000) and login in one of the demo users
(in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`.

## Development Environment

### Native Tooling

Renalware is developed against locally installed tooling rather than a repo-managed
package environment. Any Ruby version manager is fine so long as it provides
Ruby `3.4.8`; common choices are `mise`, `asdf`, `rbenv`, or `chruby`.

### Direnv

[`direnv`](https://direnv.net/) is optional. If you use it, copy
[`.envrc.example`](/Users/tim/Code/airslie/renalware/core/.envrc.example) to `.envrc`
and adjust values as needed for your machine and worktree.

### Process Management

**Infrastructure services** such as PostgreSQL run directly on your machine.

**Application processes** (web server, background workers, JS/CSS watchers) are
managed by Foreman via `bin/dev`. See [`Procfile.dev`](/Users/tim/Code/airslie/renalware/core/Procfile.dev)
for the process configuration.

This keeps infrastructure ownership explicit while allowing easy restart of
application processes during development.

### Git Hooks

After Ruby version updates, disable Overcommit hooks temporarily if `git pull` fails:
```bash
OVERCOMMIT_DISABLE=1 git pull
```

## Testing

The project includes comprehensive test coverage using RSpec for unit/integration tests and Cucumber for feature tests.

### Running Tests

```bash
# Run all tests
bundle exec rake

# Run RSpec tests only
bin/rspec

# Run Cucumber tests only
bin/cucumber

# Run combined tests with coverage report
bin/coverage
```

### Coverage Reporting

SimpleCov is integrated to track code coverage across both test suites:

- **Local development**: Run `bin/coverage` to generate a combined coverage report
- **CI/CD**: Coverage is automatically collected on every push and PR
- **Reports**: Coverage reports are deployed to GitHub Pages on main branch
- **PR feedback**: Coverage summaries are automatically posted on pull requests
- **Thresholds**: Minimum 80% overall coverage, 70% per file

Coverage reports include both line and branch coverage metrics, with detailed breakdowns by file and directory.
