require "collection_presenter"

module Renalware
  module HD
    class TransmissionLogsController < BaseController
      include PresenterHelper
      include Pagy::Backend

      # NB be sure not to select the payload as this will slow things down.
      # The payload is loaded by clicking on a link in the table
      def index
        pagy, logs = pagy(
          TransmissionLog
            .order(created_at: :desc)
            .select(TransmissionLog.attribute_names - [:payload])
        )
        authorize logs
        render locals: { logs: logs, pagy: pagy }
      end

      def show
        log = TransmissionLog.find(params[:id])
        authorize log
        respond_to do |format|
          format.xml { render xml: log.payload, template: nil }
        end
      end
    end
  end
end
