# Replaying historical pathology

## Overview

When a patient is added to Renalware via any means e.g.:
- manually through the UI
- as a result of an HL7 AKI alert
- as a result of an HL7 clinic appointment message
then we find a replay any  previously received and stored HL7 ORU pathology results messages
(looking as far back as we can) in order to build the patients pathology record for the benefit of
the clinician. This happens asynchronously just after the patient has been added, and the import
process patient's pathology should be viewable in Renalware within 10 minutes.

## Technical implementation

When a patient is added via any means, a 'patient_added' event is broadcast.
A 'listener' class intercepts this event and schedules a background job to find and replay
any pathology HL7 message we have previously received for this patient.

The pathology message to replay reside in the renalware.feed_messages table.
We identify the rows to import by matching the patient on two of any three
- NHS number
- Local patient id
- DOB
and we only take 'complete' ORU R01 message (not ones with partial results) and ignore messages
already marked as processed.
See replayable_hl7_pathology_messages_query.rb

In addition we onto feed_replay_requests and feed_replay_messages to determine that
- there is not an ongoing import operation (ie to prevent accidental re-entry)
- to only select feed_messages that have not been replayed already

We then iterate in batches over the query results for each message, broadcast an
'oru_message_arrived' event.
See app/models/renalware/feeds/replay_historical_hl7_pathology_messages.rb

From here on the normal pathology import process intercepts the event and creates the relevant
pathology_observation_* rows, which will then appear in the patient's pathology screens.
See app/models/renalware/pathology/ingestion/message_listener.rb

Note however that unlike normal realtime pathology that is imported when the patient already
exists in Renalware, the historical replay process does include AKI or KFRE or processing.
(See broadcast_subscription_map in config/initializers/renalware.rb).

In order to keep track of what pathology was replayed (to prevent another accidental replay),
when a replay is started we creat new feed_replay_request row, specifying the start date.
A replay is assumed to be ongoing unless the last replay_request has a finished_at date present.
For each message replayed within the scope of the replay_request, we create a
feed_message_replay row at the start of the message replay, and update it with the results eg
success when the message was processed, or the error if the message failed to process.
A message is assumed to be in the process of being imported if it has been created in the database
but is not marked as complete.


