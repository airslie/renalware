module Renalware
  module System
    class APILogsController < BaseController
      include Pagy::Backend

      def index
        authorize System::Message, :new?
        pagy, api_logs = pagy(APILog.order(created_at: :desc))
        render locals: { api_logs: api_logs, pagy: pagy }
      end
    end
  end
end
