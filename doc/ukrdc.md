# UKRDC integration

## Export

```bash
bundle exec rake ukrdc:export
```

## Import

PROMS (POS-S) and EQ5D patient surveys can be imported into patient_surveys tables by
running the rake task:
```bash
bundle exec rake ukrdc:import
```

Any xml files in the folder `<UKRDC_WORKING_PATH>/incoming`  will imported. `UKRDC_WORKING_PATH`
is an environment variable that can be configured in the relevant `.env` file.
Processed files will be copied to `<UKRDC_WORKING_PATH>/archive/incoming` and will need to be
periodically cleared.

The output from the import process is logged to the ukrdc_transmission_logs table. Rows have a
direction of 1 (in).
