# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to 
improve patient care, undertake clinical and administrative audits and share 
data with external systems.

## Technical Overview

`renalware-core` is an open-source Ruby On Rails [engine](http://guides.rubyonrails.org/engines.html)
that encapsulates Renalware's features in a re-usable [gem](http://guides.rubygems.org/what-is-a-gem/).

In order to deploy an instance of Renalware that is tailored to a
renal unit's needs, it is necessary to create a new host Rails application that 
includes the `renalware-core` gem, adds configuration and HTML/JavaScript/CSS 
overrides, and optionally augments or replaces core behaviour with custom Ruby 
code.

While `renalware-core` is intended to be deployed inside a host application in 
production, it can be run stand-alone in a local development environment using 
the _demo_ host application (`./demo`) that ships inside the engine.

Renalware is built using open source projects including:
- Ruby on Rails framework
- PostgreSQL database

## Running Renalware locally on Mac, Windows or Linux

### Install Microsoft corefonts

* On Ubuntu: `sudo apt install ttf-mscorefonts-installer`
* On NixOS: Add the package `corefonts` to your `configuration.nix`

```
git clone git@github.com:airslie/renalware-core.git
cd ./renalware-core
direnv allow
devbox run setup
devbox services up  # Start PostgreSQL with process-compose
bin/dev             # Start application processes (web, worker, js, css)
```
Additionally, you can run `devbox run reset` which will delete the PostgreSQL
database files for this project and then runs setup again. For a complete reset
(including removing gems) you can simply `rm -rf .devbox`. See `devbox run` for
all available scripts and `devbox.json` to see what they do.

Visit [http://localhost:3000](http://localhost:3000) and login in one of the demo users
(in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`.

## Development Environment

### Devbox & Direnv

Devbox and Direnv manage package dependencies and local environment setup. Under
the hood it uses Nix which is a declarative, immutable package manager.

**Devbox** is a cross-platform project scoped package manager. Think npm + brew.
See devbox.json for the configuration and devbox.lock for the versions. Docs at
https://www.jetify.com/docs/devbox/.

**Direnv** sets up your local environment when entering a directory. Think
chruby/dotenv. It's integrated with Devbox. Docs at https://direnv.net/.

### Process Management

**Infrastructure services** (PostgreSQL) are managed by Devbox's process-compose
integration via `devbox services up`. See `./process-compose.yml` for configuration.

**Application processes** (web server, background workers, JS/CSS watchers) are
managed by Foreman via `bin/dev`. See `Procfile.dev` for the process configuration.

This separation keeps infrastructure services running independently while allowing
easy restart of application processes during development.

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


