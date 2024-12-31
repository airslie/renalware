module Renalware
  module Pathology
    # Renders a pathology sparkline - a small graph of patient results for a particular
    # OBX (observation_description) over time.
    # TODO: Move the graph config into JS. Possibly use a stimulus controller
    class SparklineComponent < ApplicationComponent
      pattr_initialize [:current_user!, :patient!, :observation_description!]

      CHART_OPTIONS = {
        library: {
          chart: {
            type: "area",
            margin: [0, 0, 0, 0],
            height: 20,
            width: 80,
            skipClone: true,
            style: {
              overflow: "visible"
            }
          },
          credits: {
            enabled: false
          },
          title: "",
          xAxis: {
            type: "datetime",
            tickPositions: [],
            labels: {
              enabled: false
            },
            startOnTick: false,
            endOnTick: false,
            title: {
              text: nil
            }
          },
          legend: {
            enabled: false
          },
          yAxis: {
            tickPositions: [0],
            endOnTick: false,
            startOnTick: false,
            title: {
              text: nil
            },
            min: 0,
            labels: {
              enabled: false
            }
          },
          tooltip: {
            hideDelay: 0,
            outside: true,
            shared: true,
            xDateFormat: "%d-%b-%Y"
          },
          plotOptions: {
            area: {
              fillColor: {
                linearGradient: {
                  x1: 0,
                  y1: 0,
                  x2: 0,
                  y2: 1
                },
                stops: [
                  [0, "#eee"],
                  [0.5, "#fff"]
                ]
              }
            },
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
              negativeColor: "#910000",
              borderColor: "silver"
            }
          }
        }
      }.freeze

      def chart_data
        @chart_data ||= patient
          .observations
          .where(description_id: observation_description.id)
          .order(:observed_at)
          .pluck([:observed_at, :result])
      end

      def cache_key
        "#{patient.cache_key_with_version}/sparkline/#{observation_description.id}"
      end

      # Because we cache the component html inside the view sidecar, we want to
      # avoid implementing this method properly - ie checking if there anything
      # to render - as that would involve querying the database, thus negating
      # the befit of any caching.
      def render?
        true
      end

      def options
        CHART_OPTIONS
      end

      def dom_id
        @dom_id ||= ActionView::RecordIdentifier.dom_id(observation_description)
      end
    end
  end
end
