---
slug: "/Reporting/updating-views"
title: Updating SQL views
---

If you need to change your report SQL view there a few things to bear in mind.

If its is non-materialised view and you are not changing the number, name or data type of any columns in the view, you can issue
```
CREATE OR UPDATE VIEW ....
````
and this will create it it does not exist, or update it if it does.

If you are adding or removing columns, or changing their data type, you will need to drop the view
and then recreate it, i.e:

```
DROP VIEW myview;
CREATE VIEW myview ... ;
```

### Updating materialised views

You always have to drop and recreate these if you make a change:

```
DROP MATERIALIZED VIEW myview;
CREATE MATERIALIZED VIEW myview ... ;
```

:::note
If the view have created is used by another view for some reason, you also need to drop and re-create
the parent view that consumes it.
:::

See also
- [DROP VIEW](https://www.postgresql.org/docs/current/sql-dropview.html)
- [DROP MATERIALIZED VIEW](https://www.postgresql.org/docs/current/sql-dropmaterializedview.html)
