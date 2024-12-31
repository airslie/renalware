# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

## Technical Overview

`renalware-core` is a open-source Ruby On Rails [engine](http://guides.rubyonrails.org/engines.html)
that encapsulates Renalware's features in a re-usable [gem](http://guides.rubygems.org/what-is-a-gem/).
In order to deploy an instance of Renalware that is tailored to a
renal unit's needs, it is necessary to create a new host Rails application that includes the
`renalware-core` gem, adds configuration and HTML/JavaScript/CSS overrides, and optionally augments
or replaces core behaviour with custom Ruby code.

While `renalware-core` is intended to be deployed inside a host application in production, it can be run
stand-alone in a local development environment using the _demo_ host application (`./demo`)
that ships inside the engine.

Renalware is built using using open source projects including:
- Ruby on Rails framework
- PostgreSQL database

## Running Renalware locally on Mac, Windows or Linux

Install `git` if not already installed on your system.
Install the [Docker Engine](https://docs.docker.com/engine/install/) and ensure it is running.

```
git clone git@github.com:airslie/renalware-core.git
cd ./renalware-core
docker-compose run web bundle exec rake db:setup
docker-compose up -d
```

Visit [http://localhost:3000](http://localhost:3000) and login in one of the demo users
(in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`
