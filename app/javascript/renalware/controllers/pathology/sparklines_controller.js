import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chart"]

  connect() {
    // let data = this.data.get("chartData")
    // let chartId = this.chartTarget.id

    // console.log(chartId)
    // let json = [
    //     {
    //       name: "",
    //       data: data
    //     }
    //   ]
    console.log("Not implemented")
    //Highcharts.SparkLine(this.chartTarget, {})
    //     series: [{
    //         name: '',
    //         data: data
    //    }]
    // })
    //new Chartkick.LineChart(chartId, json, this.chartOptions)
  }

  // get chartOptions() {
  //   return {
  //     library: {
  //       chart: {
  //         type: "area",
  //         margin: [0, 0, 0, 0],
  //         height: 20,
  //         width: 80,
  //         skipClone: true,
  //         style: {
  //           overflow: "visible"
  //         }
  //       },
  //       credits: {
  //         enabled: false
  //       },
  //       title: "",
  //       xAxis: {
  //         type: "datetime",
  //         tickPositions: [],
  //         labels: {
  //           enabled: false
  //         },
  //         startOnTick: false,
  //         endOnTick: false,
  //         title: {
  //           text: null
  //         }
  //       },
  //       legend: {
  //         enabled: false
  //       },
  //       yAxis: {
  //         tickPositions: [0],
  //         endOnTick: false,
  //         startOnTick: false,
  //         title: {
  //           text: null
  //         },
  //         min: 0,
  //         labels: {
  //           enabled: false
  //         }
  //       },
  //       tooltip: {
  //         hideDelay: 0,
  //         outside: true,
  //         shared: true,
  //         xDateFormat: '%d-%b-%Y'
  //       },
  //       plotOptions: {
  //         series: {
  //           animation: false,
  //           lineWidth: 1,
  //           shadow: false,
  //           states: {
  //             hover: {
  //               lineWidth: 1
  //             }
  //           },
  //           marker: {
  //             radius: 1,
  //             states: {
  //               hover: {
  //                 radius: 2
  //               }
  //             }
  //           },
  //           fillOpacity: 0.25
  //         },
  //         column: {
  //           negativeColor: "#910000",
  //           borderColor: "silver"
  //         }
  //       }
  //     }
  //   }
  // }
}
  /**
  * Create a constructor for sparklines that takes some sensible defaults and merges in the individual
  * chart options.
  */

  /*
  window.Highcharts.SparkLine = function (a, b, c) {
  var hasRenderToArg = typeof a === 'string' || a.nodeName,
      options = arguments[hasRenderToArg ? 1 : 0],
      defaultOptions = {
          chart: {
              renderTo: (options.chart && options.chart.renderTo) || this,
              backgroundColor: null,
              borderWidth: 0,
              type: 'area',
              margin: [2, 0, 2, 0],
              width: 120,
              height: 20,
              style: {
                  overflow: 'visible'
              },

              // small optimization, saves 1-2 ms each sparkline
              skipClone: true
          },
          title: {
              text: ''
          },
          credits: {
              enabled: false
          },
          xAxis: {
              labels: {
                  enabled: false
              },
              title: {
                  text: null
              },
              startOnTick: false,
              endOnTick: false,
              tickPositions: []
          },
          yAxis: {
              endOnTick: false,
              startOnTick: false,
              labels: {
                  enabled: false
              },
              title: {
                  text: null
              },
              tickPositions: [0]
          },
          legend: {
              enabled: false
          },
          tooltip: {
              hideDelay: 0,
              outside: true,
              shared: true
          },
          plotOptions: {
              series: {
                  animation: false,
                  lineWidth: 1,
                  shadow: false,
                  states: {
                      hover: {
                          lineWidth: 1
                      }
                  },
                  marker: {
                      radius: 1,
                      states: {
                          hover: {
                              radius: 2
                          }
                      }
                  },
                  fillOpacity: 0.25
              },
              column: {
                  negativeColor: '#910000',
                  borderColor: 'silver'
              }
          }
      };

  options = Highcharts.merge(defaultOptions, options);

  return hasRenderToArg ?
      new Highcharts.Chart(a, options, c) :
      new Highcharts.Chart(options, b)
}

  */
