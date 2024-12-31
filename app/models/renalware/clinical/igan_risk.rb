module Renalware
  module Clinical
    class IganRisk < ApplicationRecord
      include Accountable
      belongs_to :patient, touch: true
      validates :patient, presence: true
      validates :risk,
                presence: true,
                numericality: {
                  allow_nil: true,
                  in: 0.00..100.00
                }
      has_paper_trail(
        versions: { class_name: "Renalware::Clinical::Version" },
        on: %i(create update destroy)
      )
      def self.policy_class = BasePolicy
    end
  end
end
