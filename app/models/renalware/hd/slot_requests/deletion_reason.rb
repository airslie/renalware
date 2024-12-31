module Renalware
  module HD
    module SlotRequests
      class DeletionReason < ApplicationRecord
        acts_as_paranoid
        validates :reason, uniqueness: true
      end
    end
  end
end
