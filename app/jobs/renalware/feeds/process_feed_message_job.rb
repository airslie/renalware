module Renalware
  module Feeds
    class ProcessFeedMessageJob < ApplicationJob
      def perform(sausage_id:)
        Sausage.find(sausage_id).update_column(:processed_at, Time.zone.now)
      end
    end
  end
end
