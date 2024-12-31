module Renalware
  module Letters
    class QREncodedOnlineReferenceLink < ApplicationRecord
      belongs_to :online_reference_link,
                 class_name: "System::OnlineReferenceLink",
                 counter_cache: :usage_count, # so we can find 'most used' links
                 touch: :last_used_at # so we can find 'most recently used' links
      belongs_to :letter

      def self.policy_class = BasePolicy
    end
  end
end
