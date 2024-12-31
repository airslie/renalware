require "collection_presenter"

module Renalware
  module UKRDC
    class TransmissionLogsController < BaseController
      include PresenterHelper
      include Pagy::Backend

      # NB be sure not to select the payload as this will slow things down.
      # The payload is loaded by clicking on a link in the table
      def index
        ransack_params = params.fetch(:q, {})
        ransack_params[:s] ||= "created_at desc"

        query = TransmissionLog
          .includes(:patient)
          .order(created_at: :desc)
          .select(TransmissionLog.attribute_names - [:payload])
          .ransack(ransack_params)
        pagy, logs = pagy(query.result)
        authorize logs
        render locals: { logs: logs, pagy: pagy, query: query }
      end
    end
  end
end
