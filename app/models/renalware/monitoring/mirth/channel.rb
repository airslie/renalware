module Renalware
  module Monitoring
    module Mirth
      class Channel < ApplicationRecord
        validates :name, presence: true
        validates :uuid, presence: true, uniqueness: { case_sensitive: false }
        belongs_to :channel_group
      end
    end
  end
end
