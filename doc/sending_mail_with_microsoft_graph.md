SMTP is disabled for NHSMail at some sites.
An alternative is use the Microsoft Graph API to send mail. This uses the the OAuth2
client credentials flow to send mail from a specific system account.

An additional actionmailer delivery method :microsoft_graph_api (MicrosoftGraph::DeliveryMethod)
has been added which uses MicrosoftGraph::Client (see lib folder).

To use this you need to add the following ENV vars to .env

```bash
MAIL_OAUTH_CLIENT_ID="???"
MAIL_OAUTH_CLIENT_SECRET="???" # NOT client_secret_id
MAIL_OAUTH_TENANT_ID=">??"
MAIL_OAUTH_EMAIL_ADDRESS="eg app.renalware@t8pz5.onmicrosoft.com"
```

The tricky bit is creating a development environment to get these values and test email
sending.

1. Create an Office 365 developer sandbox and login. You can see under Active Directory that is
   has created some sample users.
2. Show all in LH menu
3. Create an app registration - go to Azure AD -> Applications -> App registrations
  e.g. Name oauthtest, Single tenant, No redirect uri required
  Create
4. Still in app registrations go to Certificates and Secrets
5. Add secret name e.g. oauthsecret, Expires 24 months
6. Make a note of the Secret Value eg "F~y8Q~..." (not secret id)
7. Note tenant id, client id from app overview
8. Go to API permissions in App registration and Add - Graph -> Application Permissions - Mail.Send
9. Important! Click on Grant admin consent for MSFT
10. Decide what user you are going to use in the Active Directory to send emails from eg
    renalware@t8pz5.onmicrosoft.com (you can rename the user to make the email address more
    sensible). All users have the same password so do not change this.
11. Use the Graph API Explorer to test you can send emails. \
    https://developer.microsoft.com/en-us/graph/graph-explorer
```
sendMail using https://graph.microsoft.com/v1.0/users/app.renalware@t8pz5.onmicrosoft.com/sendMail
{
    "message": {
        "subject": "Meet for lunch?",
        "body": {
            "contentType": "Text",
            "content": "The new cafeteria is open."
        },
        "toRecipients": [
            {
                "emailAddress": {
                    "address": "test@airslie.com"
                }
            }
        ]
    }
}
= Accepted - 202 - 173ms
``
Note that emails will not actuallyu send =- you will have to login to Office365 as the dummy sending
user eg renalware@t8pz5.onmicrosoft.com and look at Sent Items.

Once it works in the graph explorer you can copy the esettings to .env and try in Renalware.
