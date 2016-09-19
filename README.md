# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

## Setup

As a Rails developer we assume you have the following setup on your machine:

* Git
* Postgres (9.5)
* a ruby version manager (e.g. RVM)
* a js runtime (i.e. nodejs) required by the [uglifier gem](https://github.com/lautis/uglifier#installation)

1. Setup a Postgres user with a password, for development purposes this can be your system login.

  ```
  sudo su - postgres
  psql template1
  ```

  At the psql prompt run the following (replacing <username> and <password> accordingly):

  ```sql
  CREATE USER <username> WITH PASSWORD '<password>';
  ALTER USER <username> SUPERUSER;
  ```

2. Ensure you have the correct Ruby version installed (verify the version in the Gemfile) and setup your Ruby
environment with your prefered Ruby version and Gemset management tool (i.e. RVM).

3. Ensure bundler installed

4. Setup the application

  ```
  bin/setup
  ```

  Important: Read the instructions outputted at the end of the setup process.

## Running the Server

    bundle exec foreman start

To see the output from the Rails server, open up another terminal window and run:

    tail -f log/developments.log

Foreman uses a Procfile to start all the components that we need for the app (server, workers, ...).

Visit [http://localhost:3000](http://localhost:3000).

## Run the tests

Ensure you have phantomjs installed in order to run the feature & integration specs.

1. Setup a test database

  ```
  RAILS_ENV=test bin/rake db:create
  bin/rake db:test:load
  ```

2. Run the test suite

  ```
  bin/rake
  ```

Test coverage reports can be found in `coverage/`

### Configuration

RSpec is configured to silence backtrace from third-party gems. This can be
configured in `.rspec` with `--backtrace` which will display the full backtrace.

### Acceptance Tests

To run the acceptance tests without the UI:

    bin/cucumber

To run the acceptance tests with the UI:

    TEST_DEPTH=web bin/cucumber --tags @web

## Code Quality

Code quality can be analyzed using by running `codeclimate analyze`. To setup
CodeClimate locally read the setup instructions:

    https://github.com/codeclimate/codeclimate

## Debugging

The [awesome_print](https://github.com/awesome-print/awesome_print) gem is available
for improved inspection formatting, for example:

    Rails.logger.ap @variable

To make awesome_print the default formatter in irb, add the following to `~/.irbrc`

    require "awesome_print"
    AwesomePrint.irb!

To make awesome_print the default formatter in pry, add the following to `~/.pryrc`

    require "awesome_print"
    AwesomePrint.pry!
