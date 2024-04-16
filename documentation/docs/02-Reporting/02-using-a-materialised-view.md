---
title: Using materialised views
---

Standard SQL views query the database every time you access the them. If the view is 'expensive' -
for example it has a lot of joins or it queries large tables - then it may be slow to run, or
impact database performance for other users. Materialised views can be useful in this instance as
they have to be refreshed on demand (manually or on a schedule, perhaps overnight), and the data in them remains cached
(as if they were tables and not views) until the next time they are refreshed. This makes them
fast to access as the data is effectively cached.

Another scenario where materialised views are useful is in displaying data up to particular point in
time but not beyond - for example the number of HD sessions yesterday (if the materialised view is refreshed
at midnight) or the number of letters created last month (if the materialised view is refreshed on the last day of the
previous month).

Follow the same procedure as creating a normal report but with these differences:

## 1. Creating the materialised view

There is slight difference to the [syntax](https://www.postgresql.org/docs/current/sql-creatematerializedview.html) used to create the view

```
CREATE materialized VIEW reporting_patients_under_40
  ....
```

### 2. Tell Renalware when to refresh the materialised view

When adding the row to `system_view_metadata` to tell Renalware about the view (as specified in Create a Report) include these additional columns:

- `materialized` true
- `refresh_schedule` a cron-style expression (eg `0 * * * *` for every hour on the hour) defining when the data in the materialised view is refreshed - use https://crontab.guru

