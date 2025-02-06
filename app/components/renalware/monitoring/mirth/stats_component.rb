module Renalware
  module Monitoring
    module Mirth
      class StatsComponent < ApplicationComponent
        pattr_initialize [:current_user!]

        def channel_stats
          ChannelStats
            .joins(:channel)
            .includes(:channel)
            .select("distinct on (channel_id) channel_id")
            .select(:created_at, :received, :sent, :queued, :error, :filtered)
            .select(channel: [:name])
            .order(:channel_id, channel: { created_at: :desc })
        end
      end
    end
  end
end
