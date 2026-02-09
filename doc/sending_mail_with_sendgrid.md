In a similar vein to sending_mail_with_microsoft_graph.md so can also send mail
with the SendGrid API (not SMTP for the same reasons stated in the graph API doc).

ENV vars:

- SENDGRID_API_KEY - required
- SENDGRID_EMAIL_ADDRESS - Defaults to MAIL_OAUTH_EMAIL_ADDRESS then DEFAULT_FROM_EMAIL_ADDRESS.

You can test this locally by setting `MAIL_DELIVERY_METHOD=sendgrid_api` in .env.
