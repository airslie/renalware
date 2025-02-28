module Renalware
  module Monitoring
    module Mirth
      class StatsComponent < ApplicationComponent
        pattr_initialize [:current_user!]

        def render? = Renalware.config.monitoring_mirth_enabled

        def channel_stats
          ChannelStats
            .joins(:channel)
            .includes(:channel)
            .select("distinct on (monitoring_mirth_channel_stats.channel_id) " \
                    "monitoring_mirth_channel_stats.channel_id")
            .select(:created_at, :received, :sent, :queued, :error, :filtered)
            .select(channel: [:name])
            .order(:channel_id, created_at: :desc)
        end
      end
    end
  end
end
