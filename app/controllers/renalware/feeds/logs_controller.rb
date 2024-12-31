module Renalware
  module Feeds
    class LogsController < BaseController
      include Pagy::Backend

      def index
        query = Feeds::Log
          .includes(:patient, :message)
          .ransack(params.fetch(:q, { s: "created_at desc" }))
        pagy, logs = pagy(query.result)
        authorize logs
        render locals: { logs: logs, pagy: pagy, query: query }
      end
    end
  end
end
