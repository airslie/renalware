# frozen_string_literal: true

module Renalware
  module Feeds
    class MessageReplaysController < BaseController
      def index
        replays = replay_request.message_replays.all
        authorize replays
        render locals: { replays: replays, replay_request: replay_request }
      end

      def replay_request
        @replay_request ||= ReplayRequest.find(params[:replay_request_id])
      end
    end
  end
end
