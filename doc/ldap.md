## LDAP configuration

If using LDAP, when a user triesd to log in to Renalware, the devise gem will make a call to the
configured LDAP service (eg ActiveDirectory on Windows, or slapd/OpenLDAP on Linux) to determine if
- the user exists in the directory
- their hashed password matches
If both are true then the user has access to Renalware _in theory_, though in fact they need to have
a Renalwere::User record in the users table in order to _actually_ login.
If they are in the directory but do not yet exists in Renalware, they will get the error messages
dinfined in devise.en.yml under the key `not_found_in_database`

> Sorry, you are not yet configured as a user. Please contact the Renalware administrator
to request access.

In development you examine the logs during login:
```
LDAP search for login: cn=tc
LDAP: LDAP search yielded 1 matches
```
but in production it is less obvious what is happening.

It possible to ask devise to only authenticate the user if they are a member of a group, e.g.
a Renalware group in Directory. See ldap_check_group_membership and the ldap.yml for options.

### Enabling

To enable LDAP to allow authentication against ActiveDirectory or OpenLDAP, in the host app:

- set `Renalware.config.ldap_authentication = true` in e.g. in the appropriate environment file
  e.g. `config/environment/production.rb`
- create a `config/ldap.yml` (using the example at renalware-core/spec/dummy/config/ldap.yml) and
  edit to set the appropriate attributes. They are case sentive so eg People != people.
- Add the following environment variables in your .env file
  - LDAP_HOST - the name or IP address of the directory server. Use localhost if testing agains OpenLDAP
  - LDAP_PORT - 389 for OpenLDAP and unsecured AD, 636 for SSL connections
  - LDAP_ADMIN_USER - credentials used by devise to query LDAP
  - LDAP_ADMIN_PASSWORD
  - LDAP_BASE - the name of the directory entry in which users are looked up
                eg "cn=users,ou=groups,dc=mydomain,dc=com"
  - LDAP_USERNAME_ATTRIBUTE eg "uid" or "cn" - that attribute that identifies the user's username
                inside the entry specified by LDAP_BASE

### Testing usingh OpenLDAP/slapd

### Set up OpenLDAP/slapd
See https://www.linux.com/news/how-install-ldap-account-manager-ubuntu-server-1804/

#### Run LAM (LDAP Account Manager) as a docker image

Once you have OpenLDAP running you use a web UI to make managing users easier, which
is useful for testing:

- create a .env file eg ~/.lamenv and past in content from [here](https://github.com/LDAPAccountManager/lam/blob/develop/lam-packaging/docker/.env)
  then edit as appropriate
- sudo docker run -p 8080:80 --env-file ~/.lamenv -d -it ldapaccountmanager/lam:stable


### TODO

- Add a means of re-initialising a local slapd directory with seed users to make using LDAP in
  test/dev easier
