module Renalware
  module Monitoring
    module Mirth
      class ChannelGroup < ApplicationRecord
        validates :name, presence: true
        validates :uuid, presence: true, uniqueness: { case_sensitive: false }
      end
    end
  end
end
