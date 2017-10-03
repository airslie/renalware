module Renalware
  module Renal
    class AKIAlertsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        alerts = AKIAlert.ordered.page(page).per(per_page)
        authorize alerts
        render locals: { alerts: alerts }
      end

      def edit
        authorize alert
        render_edit(alert)
      end

      def update
        authorize alert
        if alert.update_attributes(aki_alert_params)
          redirect_to renal_aki_alerts_path
        else
          render_edit(alert)
        end
      end

      private

      def render_edit(alert)
        render :edit, locals: { alert: alert }
      end

      def alert
        @alert ||= AKIAlert.find(params[:id])
      end

      def aki_alert_params
        params.require(:renal_aki_alert).permit(:notes)
      end
    end
  end
end
