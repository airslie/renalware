# Synchronising Practices and GPS with the NHS Organisation Data Service (ODS)

GP and practice data are stored in these database tables:

```
patient_practices (practices/surgeries)
patient_primary_care_physicians (GPs)
patient_practice_memberships (which GP is at which practice)
```

When you deploy Renalware for the first time, it won’t have many (or any) practices and GPs in the these tables (the demo data if you have installed it has about 25 practices). However it will have set up a cron job that overnight fetches updates from the [NHS Organisation Data Service (ODS)](https://digital.nhs.uk/services/organisation-data-service/data-downloads/gp-and-gp-practice-related-data) api, so that the next day you will find there are 18,000+ practices (and even more GPs) in the the database.

If you have say a migration server which you turn off over night so the cron job does not run, or you want to just manually run the sync process, you can trigger it with:

```bash
cd ~/apps/renalware/current
bundle exec rake ods:sync
```

> This rake task kicks of a background job to do the actual work. If you have deployed Renalware
with capistrano then it will have started a background worker for you and there is nothing else to
do. If you are running locally in development mode you will need to start a worker with
`bundle exec rake jobs:work`

See
- https://digital.nhs.uk/services/organisation-data-service/data-downloads/gp-and-gp-practice-related-data
- lib/tasks/ods.rake

## Implementation details

### Practices
These are synced using the [ODS API](https://directory.spineservices.nhs.uk/ORD/2-0-0/organisations?PrimaryRoleId=RO177).

### GPs and GP -> Practice memberships
These are imported by downloading the current CSV for each and passing the path to the CSV to
a corresponding Renalware SQL function which imports the data usin the Postgres `COPY` command.
**Note that currently if the PostreSQL database is on a different server (or another Docker
container) to the Renalware application code, `COPY` will fail (PG needs the file to be local to
the database server). There is an open issue to remove the use of `COPY` for this reason.**

## Migration notes

You will need to sync GPS and practices before migrating patient data across.
A patient has a `practice_id` and and `primary_care_physician_id`. These are foriegn keys into
`patient_pratices` and `patient_primary_care_physicians` tables.
If you have a patient that you know belongs to a pratice 'A81010', you will need to look up
that practice row in patient_practices and use its id as practice_id when inserting into
the patients table. Likewise for primary_care_physcian: if you have a GP code like 'G3141373'
 you will need to look that code the primary_care_physciansto get the id.

> **Letters** Note that letters are snail-mailed/emailed to the practice's address/email, not the GP's address.
Generally it seems that the GP name is less and less significant, and the important thing is to get
the practice right. If a GP moves away from the practice, letters will still be addressed to them
until the patient's GP is updated in Renalware, but this is not generally an issue.
