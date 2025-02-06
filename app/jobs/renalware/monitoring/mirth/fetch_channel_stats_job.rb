module Renalware
  module Monitoring
    module Mirth
      class FetchChannelStatsJob < ApplicationJob
        def perform = FetchChannelStats.call
      end
    end
  end
end
