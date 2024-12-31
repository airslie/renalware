json = {
  chart: {
    type: "spline",
    height: "600px",
    zoomType: "xy"
  },
  title: {
    text: "Chart title"
  },
  xAxis: {
    type: "datetime",
    title: {
      text: "Date"
    },
    column: "date",
    dateTimeLabelFormats: {
      day: "%e %b",
      year: "%Y",
      month: "%b %Y"
    }
  },
  yAxis: {
    min: 0,
    title: {
      text: "m/s"
    }
  },
  colors: %w(violet orange yellow),
  series: [
    {
      data: [],
      name: "Series 1",
      type: "line",
      column: "series1"
    },
    {
      data: [],
      name: "Series 2",
      type: "column",
      column: "series2"
    }
  ],
  tooltip: {
    pointFormat: "{point.x:%e. %b}: {point.y:.2f} m",
    headerFormat: "<b>{series.name}</b><br>"
  },
  subtitle: {
    text: "A subtitle here"
  },
  plotOptions: {
    series: {
      marker: {
        radius: 2.5,
        symbol: "circle",
        enabled: true,
        description: "See the system_metadata.chart_raw colum for the Highcharts chart " \
                     "definition, and look at https://docs.renalware.com/Reporting " \
                     "and https://www.highcharts.com/demo",
        fillColor: "#FFFFFF",
        lineColor: nil,
        lineWidth: 1
      }
    }
  }
}

Renalware::System::ViewMetadata.create!(
  schema_name: "renalware_demo",
  view_name: "reporting_example_data",
  category: "report",
  scope: "patients",
  title: "Example report to demonstrating charting",
  chart_raw: json
)
