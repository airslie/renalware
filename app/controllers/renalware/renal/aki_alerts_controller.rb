# frozen_string_literal: true

module Renalware
  module Renal
    class AKIAlertsController < BaseController
      include Renalware::Concerns::Pageable
      include Renalware::Concerns::PdfRenderable

      def index
        query = search_form.query
        alerts = query.call
        authorize alerts

        respond_to do |format|
          format.pdf { render_index_pdf(query, alerts) }
          format.html { render_index_html(query, alerts) }
        end
      end

      def edit
        authorize alert
        render_edit(alert)
      end

      def update
        authorize alert
        if alert.update(aki_alert_params.merge(by: current_user))
          redirect_to renal_aki_alerts_path
        else
          render_edit(alert)
        end
      end

      private

      def render_index_pdf(query, alerts)
        options = default_pdf_options.merge!(
          pdf: "AKI Alerts #{I18n.l(Time.zone.today)}",
          locals: {
            alerts: alerts,
            form: search_form,
            search: query.search,
            path_params: path_params
          }
        )
        render_with_wicked_pdf options
      end

      def render_index_html(query, alerts)
        render locals: {
          alerts: alerts.page(page).per(per_page),
          form: search_form,
          search: query.search,
          path_params: path_params
        }
      end

      def search_form
        @search_form ||= begin
          options = params.key?(:q) ? search_params : {}
          AKIAlertSearchForm.new(options)
        end
      end

      def render_edit(alert)
        render :edit, locals: { alert: alert }
      end

      def alert
        @alert ||= AKIAlert.find(params[:id])
      end

      def aki_alert_params
        params
          .require(:renal_aki_alert)
          .permit(
            :notes, :action_id, :hotlist, :hospital_ward_id, :hospital_centre_id,
            :max_cre, :cre_date, :max_aki, :aki_date
          )
      end

      # rubocop:disable Metrics/MethodLength
      def search_params
        params
          .require(:q)
          .permit(
            :date,
            :term,
            :on_hotlist,
            :action,
            :hospital_unit_id,
            :hospital_ward_id,
            :hospital_centre_id,
            :max_aki,
            :date_range,
            :s
          )
      end
      # rubocop:enable Metrics/MethodLength

      def path_params
        params.permit([:controller, :action])
      end
    end
  end
end
