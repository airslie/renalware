---
title: Graphing
---

:::note
This is a work in progress!
:::

## Full-control via `chart_raw`

Renalware currently uses [Highcharts](https://www.highcharts.com) for charting.

When viewing a report, if you have added a jsonb definition in the `chart_raw` column for the associated
`renalware.system_view_metadata` row, then a tab called Chart appears.

Whatever json you put into `chart_raw` is used to generate the chart, but here are some things to
note.

### Consuming your view data

Highcharts works with `axes` and `series`, where a series is a column from your view that you want
to plot.

In the following example we have a SQL view with a `date` column containing the first day in every
week in 2023. We then have columns `series1` and `series2` containing some example data.

Our intent is to plot series1 and series2 over time. We use the `date` column for the x axis,
and `series1` and `series2` share the left hand y axis for their units
(though we could use the right hand axis for ome of them).
We will make series1 a line chart and series2 a bar chart, just to be fancy.

The SQL view
```SQL
create or replace view renalware_demo.reporting_example_data as
  with dates as (
    SELECT date_trunc('day', dd)::date AS dt
        FROM generate_series
        ( '2023-01-01'::timestamp
        , '2023-12-31'::timestamp
        , '1 week'::interval) dd
  )
  select
    dates.dt::date as date,
    (10 + 9*random())*(row_number() over()) as series1,
    (2 + 7*random())*(row_number() over()) as series2
  from dates;
```

Its associated row in `renalware.system_view_metadata`
```SQL
insert
  into
  system_view_metadata (schema_name,
  view_name,
  "scope",
  title,
  display_type,
  category,
  chart_raw)
values
(
  'renalware_demo',
  'reporting_example_data',
  'patients',
  'Example report to demonstrate charting',
  'tabular',
  'report',
  '{
    "chart": { "type": "spline", "height": "600px", "zoomType": "xy" },
    "title": { "text": "Chart title" },
    "xAxis": {
      "type": "datetime",
      "title": { "text": "Date" },
      "column": "date",
      "dateTimeLabelFormats": { "day": "%e %b", "year": "%Y", "month": "%b %Y" }
    },
    "yAxis": { "min": 0, "title": { "text": "m/s" } },
    "colors": ["violet", "orange", "yellow"],
    "series": [
      { "data": [], "name": "Series 1", "type": "line", "column": "series1" },
      { "data": [], "name": "Series 2", "type": "column", "column": "series2" }
    ],
    "tooltip": {
      "pointFormat": "{point.x:%e. %b}: {point.y:.2f} m",
      "headerFormat": "<b>{series.name}</b><br>"
    },
    "subtitle": { "text": "A subtitle here" },
    "plotOptions": {
      "series": {
        "marker": {
          "radius": 2.5,
          "symbol": "circle",
          "enabled": true,
          "fillColor": "#FFFFFF",
          "lineColor": null,
          "lineWidth": 1
        }
      }
    }
  }'
);
```

The important bit here is the mapping of the series in the the json to the columns in your SQL view.
Note the series data is just '[]' as we will inject the data at the runtime.
```json
"series": [
  { "data": [], "name": "Series 1", "type": "line", "column": "series1" },
  { "data": [], "name": "Series 2", "type": "column", "column": "series2" }
]
```

![Example chart](/img/example-chart.jpg)
