# relay-gp_connect

Sends a document (a PDF letter) to a patient's GP using the NHS **GP Connect 'Send Document'**
workflow over **MESH**.

It is shared by Renalware (which uses it for its built-in GP letter delivery) and Relay. It is
deliberately independent of both: no Rails, no ActiveRecord, no global configuration.

## What it does

- builds the FHIR STU3 message (`Relay::GPConnect::FHIR`) from a `DeliveryRequest`
- talks to the MESH API (`Relay::GPConnect::Mesh`): send, check inbox, download, acknowledge,
  handshake, endpoint lookup
- parses what comes back (MESH errors, ITK3 infrastructure/business responses) into plain
  attributes

## What it does not do

Storing anything, queueing jobs, deciding whether a letter should be sent, or acting on the
outcome. Those belong to the host application.

## Running the specs

From this directory (no database or Rails needed):

    bundle exec rspec
