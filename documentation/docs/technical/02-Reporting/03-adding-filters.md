---
slug: "/Reporting/adding-filters"
title: Adding filters
---

You can filter by any column in your SQL view.

To add filters you update the `filters` column in the `system_view_metadata` column.

## Dropdown filters

For example if you view has a column 'age' and you want a dropdown of distinct values so
you can choose only patient with an age say of 39, you can update `system_view_metadata.filters` with

```
[{"code": "age", "type": 0}]
```

:::note
Filter type 'list' = a drop downlist of all possible options
Filter type 'multi' = a drop downlist of all possible options
Filter type 'search' = a searchable text input
:::

![Filter example](/img/report-filters.jpg)

## Multi-select filters

```
[{"code": "age", "type": "multi"}]
```

![Filter example](/img/report-filter-multiselect.jpg)

## Text search filters

If you want to allow searching on a specific column in your report - eg patient_name in our case -
you can add another filter to `system_view_metadata.filters` of type 'search'

```
[
  {"code": "patient_name", "type": "search"},
  {"code": "age", "type": "list"},
]
```
![Filter example](/img/report-multiple-filters.jpg)
