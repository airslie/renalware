# Entra OpenID Connect

As a backup if LDAP is problematic. OIDC seems to be the more modern way to authenticate with Entra (Azure AD).
Implementation fairly straightforward but requires some config in Entra

### Advantages over LDAP
- we are not handling user passwords
- errors like account disabled, password expired, password needs changing - these are displayed for us by Azure
  and we don't need to dig around in LDAP functional properties for deduce that eg max password attempts exceeded
- we can more easily support a manual (username/pwd) login for emergency use, as we are not overloading the username/password inputs


### Entra config

- need an Entra resource in your Azure subscription. Must be created as a native Azure directory and not an external one.
- create new app registration 'Renalware'
- create app roles read_only and clinical and assign AD groups or users into them
- under authentication
  - use callback eg http://localhost:3000/users/auth/entra_id/callback (type web)
  - check ID tokens
  - Accounts in this org only
- create a secret called ENTRA_CLIENT_ID and copt the value into .env as ENTRA_CLIENT_ID
- Under API permissions be sure to have (under MS Graph) email, offline_access, openid, profile, User.Read

### To test

- create users in Entra and add them to the app roles (need a paid plan to be able to o this via group membership, otherwise add user individually)
- make sure they have fn sm email
- login as those users by clicking on the Sign in with Microsoft button

To consider at a Trust
- check sAMAccountName -> onPremisesSamAccountName mapping for synced AD and use this for username
- if we can't save the user because email or first name or given name are blank, how is that displayed to the user
