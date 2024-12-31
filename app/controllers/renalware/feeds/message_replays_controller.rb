module Renalware
  module Feeds
    class MessageReplaysController < BaseController
      include Pagy::Backend

      def index
        pagy, replays = pagy(replay_request.message_replays.order(created_at: :desc))
        authorize replays
        render locals: { replays: replays, replay_request: replay_request, pagy: pagy }
      end

      def replay_request
        @replay_request ||= ReplayRequest.find(params[:replay_request_id])
      end
    end
  end
end
