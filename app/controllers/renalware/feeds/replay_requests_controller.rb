# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayRequestsController < BaseController
      def index
        replay_requests = ReplayRequest.all
        authorize replay_requests
        render locals: { replay_requests: replay_requests }
      end
    end
  end
end
