# relay-gp_connect

Sends a document (a PDF letter) to a patient's GP using the NHS **GP Connect 'Send Document'**
workflow over **MESH**.

It is shared by Renalware (which uses it for its built-in GP letter delivery) and Relay. It is
deliberately independent of both: no Rails, no ActiveRecord, no global configuration. Its specs run
without any of them (`spec/relay/gp_connect_standalone_spec.rb` fails if Rails gets loaded).

## The pieces

| | |
|---|---|
| `Relay::GPConnect::DeliveryRequest` | What to send, as plain immutable values: patient, author, document (with the PDF), sender organisation, routing. The one thing a host application builds. |
| `Relay::GPConnect::FHIR::BuildPayload` | Turns a request (wrapped in `FHIR::Arguments`) into the FHIR STU3 XML message NHS England assured. |
| `Relay::GPConnect::Mesh::Config` | The settings the MESH classes need (mailbox, credentials, certificates, URLs, clock). The host builds one and passes it in. |
| `Relay::GPConnect::Mesh::Client` | The MESH API: send message, check inbox, download, acknowledge, handshake, endpoint lookup. |
| `Relay::GPConnect::Mesh::OperationAttributes` | Turns a MESH response into plain attributes (HTTP outcome, MESH error, ITK3 infrastructure/business response) for the host to store. |
| `Mesh::ResponseHeaders`, `Mesh::ITK3Response` | Read the `Mex-*` headers and the ITK3 XML response. |

## Using it

```ruby
# 1. Describe what to send (a host builds this from its own data)
request = Relay::GPConnect::DeliveryRequest.new(patient:, author:, document:, sender:, routing:)

# 2. Build the message
arguments = Relay::GPConnect::FHIR::Arguments.new(
  request:, transmission_uuid: SecureRandom.uuid, transaction_uuid: SecureRandom.uuid
)
xml = Relay::GPConnect::FHIR::BuildPayload.call(arguments)

# 3. Send it
config = Relay::GPConnect::Mesh::Config.new(mailbox_id: "...", ...)
Relay::GPConnect::Mesh::Client.new(config:).send_message(
  xml, operation_uuid: SecureRandom.uuid, to: arguments.mex_to, subject: arguments.mex_subject
)
```

## What it does not do

Storing anything, queueing jobs, deciding whether a letter should be sent, or acting on the
outcome. Those belong to the host application. Renalware, for example, stores each MESH call in an
`Operation` row, and decides what a successful or failed delivery means for the letter.

## Rules for changing this gem

- **The XML is assured.** `spec/relay/gp_connect/fhir/build_payload_spec.rb` compares the output
  with `spec/fixtures/gp_connect_send_document.xml` byte for byte. Do not change the fixture
  unless the payload change is deliberate and has been re-assured by NHS England.
- **Do not reach for the host.** No `Renalware`, no `Rails`, no global config, no database. If you
  need a setting, add it to `Mesh::Config` or `DeliveryRequest`. The standalone spec enforces this.
- **Require what you use.** Outside Rails, nothing is loaded for you (`Date`, `Base64`, Active
  Support extensions...). Missing requires show up as `NameError` in this gem's specs.

## Known behaviour worth knowing

- **TLS.** `Mesh::Client` currently connects with `verify: false` (the NHS endpoints use a private
  CA). This is pinned by a spec so it cannot change unnoticed. Enabling verification is a
  deliberate change that needs testing against a real MESH environment.
- **Auth header time.** The MESH authorization header is timestamped by `config.clock`, which
  defaults to UTC. Renalware passes its application time zone (London) to preserve what it has
  always sent.

## Running the specs

From this directory (no database or Rails needed):

    bundle exec rspec

This gem lives inside the Renalware repository for now and is used as a path gem; it is designed
to be moved to its own repository (with history: `git subtree split` or `git filter-repo`) when
Relay needs to depend on it.
