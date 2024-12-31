module Renalware
  module Transplants
    class DonorFollowup < ApplicationRecord
      belongs_to :operation,
                 class_name: "DonorOperation",
                 touch: true

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )

      validates :last_seen_on, timeliness: { type: :date, allow_blank: true }
      validates :dead_on, timeliness: { type: :date, allow_blank: true }

      def self.policy_class = BasePolicy
    end
  end
end
