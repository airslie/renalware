module Renalware
  module Monitoring
    module Mirth
      class ChannelStats < ApplicationRecord
        validates :channel, presence: true
        validates :received, numericality: true
        validates :sent, numericality: true
        validates :queued, numericality: true
        validates :error, numericality: true
        validates :filtered, numericality: true
        belongs_to :channel
      end
    end
  end
end
