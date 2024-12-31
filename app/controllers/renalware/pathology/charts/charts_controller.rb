module Renalware
  module Pathology
    module Charts
      # Unused?
      class ChartsController < BaseController
        # GET html
        # Render the data-defined charts all together under the Pathology Charts tab
        def index
          authorize patient
          charts = Chart.where(scope: "charts").order(:display_group, :display_order)
          render locals: { patient: patient, charts: charts }
        end

        # GET json: render json required to display the chart for the current patient and period
        # GET html: render the modal dialog markup - a subsequent call will fetch the chart json
        def show
          authorize patient
          respond_to do |format|
            format.json do
              render json: chart.chart_series_json(patient_id: patient.id, start_date: start_date)
            end
            format.html do
              render locals: { patient: patient, chart: chart }, layout: false
            end
          end
        end

        private

        def chart
          @chart ||= Chart.find(params[:id])
        end

        def start_date
          PeriodMap[period]
        end

        def period
          params[:period]
        end
      end
    end
  end
end
