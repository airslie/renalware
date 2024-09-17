

## Working CURL examples

### Handshake to RAJ01OT001

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
