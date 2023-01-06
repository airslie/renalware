# Renalware

[![Maintainability](https://api.codeclimate.com/v1/badges/644897239eebaf83f564/maintainability)](https://codeclimate.com/github/airslie/renalware-core/maintainability)
[![Test Coverage](https://codeclimate.com/repos/58beee3ed41d600266000147/badges/50451f89d7aad6c2d200/coverage.svg)](https://codeclimate.com/repos/58beee3ed41d600266000147/coverage)
[![Gem Version](https://badge.fury.io/rb/renalware-core.svg)](https://badge.fury.io/rb/renalware-core)

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

## Technical Overview

renalware-core is a Ruby On Rails [engine](http://guides.rubyonrails.org/engines.html) encapsulating the majority of Renalware's
features in a re-usable [gem](http://guides.rubygems.org/what-is-a-gem/). When a renal unit deploys Renalware, it will create its own _host_
Rails application, and configure it to include the Renalware engine. The host application may be
extremely thin, adding no custom features other than site-specific configuration, or it may include
Ruby, HTML and JavaScript to override or augment renalware-core's features.

While the engine is intended to be deployed inside a host application in production, it can be run
stand-alone in a local development environment (or indeed deployed in a limited way to somewhere like Heroku) by employing
the _dummy_ host application that ships inside the engine. This dummy app (in `./spec/dummy`)
allows a developer to quickly mount the engine, and is used also used by Rails integration tests (which is why
it is in the `./spec` folder)

## Get up and running locally

> An alternative Docker approach will be available shortly

As a Rails developer we assume you are using OS X or Linux (natively or inside a [VM](https://www.virtualbox.org/wiki/Downloads) on Windows),
and have the following installed:

* Git
* Postgres 12+
* a ruby version manager (e.g. [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/))
* NodeJS required by the [uglifier gem](https://github.com/lautis/uglifier#installation)

### Postgres setup

Set up Postgres user with a password - for development purposes this can be your system login.

```bash
sudo su - postgres
psql template1
```

At the psql prompt run the following (replacing `<username>` and `<password>` accordingly):

```sql
CREATE USER renalware WITH PASSWORD 'renalware';
ALTER USER renalware WITH SUPERUSER;
ALTER USER renalware WITH LOGIN;
```

### Configure Ruby

Check the `ruby` declaration at the top of the Gemfile to see which version of Ruby to install
using your preferred Ruby version manager.
If using rbenv for example:
```bash
rbenv install <version>
cd renalware-core
rbenv local <version>
```

### Install app dependencies and seed the database with demo data

```bash
gem install bundler --conservative
bundle exec rake db:setup
```

### Run the server

```
$ bin/dev
```

> Note `bin/dev` starts a sever in the spec/dummy directory. Just executing `rails server` will not work.

Visit [http://localhost:3000](http://localhost:3000)

Login in one of the demo users (in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`

## Running tests

### Install chromedriver

#### MacOS

- Install Chrome
- Download chromedriver from eg [here](https://chromedriver.storage.googleapis.com/index.html)
- Unzip and place in location in your PATH eh `/usr/local/bin`
- If you have chromedriver errors it maybe your installed version of Chrome is not
compatible your chromedriver version. In this case check your versions with:

```
chromedriver -v
chrome -v
```
and consult the driver release notee eg for [2.38](https://chromedriver.storage.googleapis.com/2.38/notes.txt)
to check compatibility

#### Ubuntu

```
sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
sudo echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
sudo apt-get -y update
sudo apt-get -y install google-chrome-stable
```

Download latest chromedriver from wget https://chromedriver.storage.googleapis.com/index.html e.g.

```
wget https://chromedriver.storage.googleapis.com/81.0.4044.69/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
sudo chown root:root /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
```


### RSpec unit and integration tests

    bundle exec rspec

### Cucumber acceptance tests

Run domain tests which bypass the UI:

    bundle exec cucumber

Run web tests exercising the UI:

    bundle exec cucumber TEST_DEPTH=web --profile rake_web

> Test coverage reports can be found in `coverage/`

## Code Quality

Code quality can be analyzed using by running `codeclimate analyze`. To setup
CodeClimate locally read the setup instructions:

    https://github.com/codeclimate/codeclimate

## Deploying

## General notes

#### Engine migrations

`config.active_record.schema_format = :sql` in `application.rb` is used the engine
uses Postgres views and functions which are not properly supported in a `schema.rb`

##### Creating scenic views

As we are an engine this is the workaround for now.
```sh
  bundle exec spec/dummy/bin/rails generate scenic:view my_view_name
```
Then copy the new files from spec/dummy/db/views and spec/dummy/db/migrations
to ./db/views and ./db/migrations

#### Throttling login attempts

[rack-attack](https://github.com/kickstarter/rack-attack) is configured to throttle login attempts.
Only 10 attempts per username as permitted in any one minute in an attempt to thwart login attacks.

#### Test Configuration

RSpec is configured to silence backtrace from third-party gems. This can be
configured in `.rspec` with `--backtrace` which will display the full backtrace.

#### Docker - WIP

```
docker-compose run web bundle exec rake db:setup
docker-compose up -d
```

#### Browser testing

<a href="https://www.browserstack.com">
<img alt="Browserstack logo" src="doc/Browserstack-logo.svg" width="188" height="43" >
</a>
