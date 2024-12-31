module Renalware
  module Letters
    class BatchItem < ApplicationRecord
      belongs_to :letter
      belongs_to :batch, counter_cache: true
      enum :status, { queued: 0, compiled: 10 }

      def self.policy_class = BasePolicy
    end
  end
end
