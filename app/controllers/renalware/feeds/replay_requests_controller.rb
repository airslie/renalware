module Renalware
  module Feeds
    class ReplayRequestsController < BaseController
      include Pagy::Backend
      def index
        pagy, replay_requests = pagy(ReplayRequest.order(started_at: :desc))
        authorize replay_requests
        render locals: { replay_requests: replay_requests, pagy: pagy }
      end
    end
  end
end
