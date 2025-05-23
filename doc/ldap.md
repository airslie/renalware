## LDAP configuration

> See ldap.yml for how the app is configured.

If using LDAP, when a user tries to log in to Renalware, the devise gem will make a call to the
configured LDAP service (eg ActiveDirectory on Windows, or slapd/OpenLDAP on Linux) to determine if
- the user exists in the directory in the requested group eg 'renalware'
- their hashed password matches
If both are true, then the user has access to Renalware.
If they do not exist in Renalware
- the devise_ldap_authenticatable gem will we create a User record for them
- we give them the clinical role (TBC).
- we query LDAP for their email and name.
If they already exist as a user in Renalware, we log them in.

### Logging

In development you can examine the logs during login by running this e.g. in another terminal
```
tail -f demo/log/development.log | grep LDAP
```
and see e.g.
```
LDAP search for login: cn=tc
LDAP: LDAP search yielded 1 matches
```
but in production it is less obvious what is happening.

### Enabling

To enable LDAP to allow authentication against ActiveDirectory or OpenLDAP, in the host app:

- set `config.ldap_authentication = true` in the appropriate environment file
  e.g. `config/environment/production.rb`
- create a `config/ldap.yml` (using the example at renalware-core/spec/dummy/config/ldap.yml) and
  edit to set the appropriate attributes. They are case sensitive so eg People != people.
- Add the following environment variables in your .env file
  - LDAP_HOST - the name or IP address of the directory server. Use localhost if testing agains OpenLDAP
  - LDAP_PORT - 389 for OpenLDAP and unsecured AD, 636 for SSL connections
  - LDAP_ADMIN_USER - credentials used by devise to query LDAP
  - LDAP_ADMIN_PASSWORD
  - LDAP_BASE - the name of the directory entry in which users are looked up
                eg "cn=users,ou=groups,dc=mydomain,dc=com"
  - LDAP_USERNAME_ATTRIBUTE eg "uid" or "cn" - that attribute that identifies the user's username
                inside the entry specified by LDAP_BASE

### Testing using OpenLDAP

Spin up OpenLDAP in a docker container saving this to a docker-compose.yml file and running
`docker compose up` in that folder

```
version: '3.9'

services:
  openldap:
    # Apple M1 Chip
    # platform: linux/amd64
    image: bitnami/openldap:latest
    container_name: openldap
    restart: always
    env_file:
      - .env
    environment:
      LDAP_ROOT: dc=woodpigeon,dc=com
      LDAP_ADMIN_USERNAME: admin
      LDAP_ADMIN_PASSWORD: $DB_PASSWORD
      LDAP_USERS: user01,user02
      LDAP_PASSWORDS: password1,password2
    ports:
      - 389:1389
      - 636:1636
    volumes:
      - openldap_datadir:/bitnami/openldap/
    networks:
      - openldap-network

networks:
  openldap-network:
    driver: bridge

volumes:
  openldap_datadir:
```

### Set up OpenLDAP/slapd

See https://www.linux.com/news/how-install-ldap-account-manager-ubuntu-server-1804/

### A GUI to manage LDAP

A couple of options

#### Apache Directory Studio

You may need to run using JDK 11 under Rosetta on a mac. Ask ChatGPT.

#### LDAPAccountManager

- create a .env file eg ~/.lamenv and past in content from [here](https://github.com/LDAPAccountManager/lam/blob/develop/lam-packaging/docker/.env)
  then edit as appropriate
- sudo docker run -p 8080:80 --env-file ~/.lamenv -d -it ldapaccountmanager/lam:stable

(or add to )

### TODO

- Add a means of re-initialising a local slapd directory with seed users to make using LDAP in
  test/dev easier
