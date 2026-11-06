

## Working CURL examples

### Handshake example

```
curl -k \
  --request 'GET' \
  --cacert './config/certificates/mesh/sub_and_root_ca.pem' \
  --key './config/certificates/mesh/Renalware.RAJ01.api.mesh-client.nhs.uk.key' \
  --cert './config/certificates/mesh/Renalware.RAJ01.api.mesh-client.nhs.uk.cer' \
  --header 'Authorization: RAJ01OT001:13230b4f-41a4-454e-8de4-514dc4df633b:0:202303101009:cb836377d7e8a9e332ce3c43b06f31ac0e6d23b820b5c003ee0e13a72cd2c47e' \
  --header 'Mex-ClientVersion: ApiDocs==0.0.1' \
  --header 'Mex-OSArchitecture: x86_64' \
  --header 'Mex-OSName: Linux' \
  --header 'Mex-OSVersion: #44~18.04.2-Ubuntu' \
  https://msg.intspineservices.nhs.uk/messageexchange/RAJ01OT001
```

Last tried 10/3/23

response {"mailboxId":"RAJ01OT001"}

## Plan

1. Wire up end to end with mesh sandbox
1. Wire up to INT env? SSL mayhem
6. Backfill tests once we know the approach works
7. Write tests for each IKT3 assurance

keep in mind spitting everything out to a separate gem
document mesh sandbox docker setup in mailbox.jsonl

Send msg

curl -k \
--request 'POST' \
--header 'Authorization: NHSMESH RAJ01OT001:6597c29a-cc87-4432-9d5d-d70b64081593:0:202303011755:2dcbb61622a334b7f7bb33b594c56779e50992d6f7bae1ef84dcb196856e6039' \
--header 'Content-Type: application/octet-stream' \
--header 'Mex-From: RAJ01OT001' \
--header 'Mex-To: RAJ01OT001' \
--header 'Mex-WorkflowID: API-DOCS-TEST' \
--header 'Mex-FileName: None' \
--header 'Mex-LocalID: api-docs-bob-greets-alice' \
--data 'This is a message' \
http://localhost:8700/messageexchange/RAJ01OT001/outbox
