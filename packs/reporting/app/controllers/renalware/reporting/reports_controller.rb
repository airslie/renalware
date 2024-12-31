module Renalware
  module Reporting
    class ReportsController < BaseController
      include Pagy::Backend
      helper Engine.helpers

      class ReportOptions
        attr_reader_initialize [
          :search!,
          :rows!,
          :current_view!,
          :view_proc,
          :pagination!,
          :report_path_without_params,
          :reset_path,
          :report_csv_download_path_with_params
        ]
      end

      def index
        authorize System::ViewMetadata, :index?
        render locals: {
          reports: reports_search.result,
          search: reports_search
        }
      end

      def show
        respond_to do |format|
          format.html { show_html }
          format.csv { show_csv }
        end
      end

      def content
        show_html(content_only: true)
      end

      def chart
        respond_to do |format|
          format.html { show_html(content_only: true) }
          format.json { chart_json }
        end
      end

      def chart_raw
        respond_to do |format|
          format.html { show_html(content_only: true) }
          format.json { chart_raw_json }
        end
      end

      private

      # rubocop:disable Metrics/MethodLength
      def show_html(content_only: false)
        sql_view_klass = build_sql_view_klass
        search = sql_view_klass.ransack(params[:q])
        pagy, rows = content_only ? pagy(search.result) : [nil, nil]

        unless content_only
          current_view.calls.create!(user: current_user, called_at: Time.zone.now)
        end

        options = ReportOptions.new(
          search: search,
          rows: rows&.load,
          current_view: current_view,
          pagination: pagy,
          report_path_without_params: reporting.content_report_path(current_view),
          reset_path: reporting.report_path(current_view),
          report_csv_download_path_with_params: report_csv_download_path_with_params
        )
        render locals: { options: options }
      end
      # rubocop:enable Metrics/MethodLength

      def show_csv
        sql_view_klass = build_sql_view_klass
        search = sql_view_klass.ransack(params[:q])
        response.headers["Content-Type"] = "text/csv"

        send_data(
          sql_view_klass.to_csv(search.result.load),
          filename: csv_filename_for(current_view)
        )
      end

      def chart_json
        chart = current_view.chart
        return if chart.x_axis_column.blank?

        sql_view_klass = build_sql_view_klass
        search = sql_view_klass.ransack(params[:q])
        relation = search.result.load
        render json: chart.generate_json(relation)
      end

      # rubocop:disable Metrics/MethodLength
      def chart_raw_json # rubocop:disable Metrics/AbcSize
        chart = current_view.chart_raw

        sql_view_klass = build_sql_view_klass
        search = sql_view_klass.ransack(params[:q])
        relation = search.result.load
        all_series = chart["series"]
        unless all_series
          render json: "No series element found in json"
          return
        end

        x_axis_column = chart["xAxis"]["column"]
        unless x_axis_column
          render json: "no 'column' key found under 'xAxis' in json"
          return
        end
        series_count = 0
        relation.column_names.each do |column_name|
          series = all_series.find { |s| s["column"] == column_name }
          next unless series

          series_count += 1
          # rubocop:disable Style/RescueModifier
          series["data"] = relation.map do |x|
            [
              x.send(x_axis_column.to_sym).to_datetime.utc.to_i * 1000,
              (x.send(column_name.to_sym) rescue nil)
            ]
          end
          # rubocop:enable Style/RescueModifier
        end

        if series_count.zero?
          render json: "No 'column' key found under any 'series' entry in the json"
          return
        end

        render json: current_view.chart_raw
      end
      # rubocop:enable Metrics/MethodLength

      def report_csv_download_path_with_params
        reporting.report_path(
          current_view,
          format: :csv,
          params: request.params.slice("q")
        )
      end

      # E.g. "My Report - 24-Aug-2022 16-34.csv"
      def csv_filename_for(_view)
        unsanitized_filename =
          "#{current_view.title || current_view.view_name} - #{I18n.l(Time.zone.now)}.csv"
        ActiveStorage::Filename.new(unsanitized_filename).sanitized
      end

      def view_name
        "#{current_view.schema_name}.#{current_view.view_name}"
      end

      def build_sql_view_klass
        @build_sql_view_klass ||= SqlView.new(view_name).klass.tap(&:reset_column_information)
      end

      def reports_search
        @reports_search ||= System::ViewMetadata
          .where(category: :report)
          .ransack(params.fetch(:q, { s: "title asc" }))
      end

      def find_and_authorize_report
        @find_and_authorize_report ||=
          System::ViewMetadata.find(params[:id]).tap { |report| authorize report }
      end

      def current_view
        @current_view ||= find_and_authorize_report
      end
    end
  end
end
