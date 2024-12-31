module Renalware
  module Clinical
    class DryWeight < ApplicationRecord
      include PatientScope
      include Accountable
      include RansackAll

      belongs_to :patient, class_name: "Renalware::Clinical::Patient", touch: true
      belongs_to :assessor, class_name: "User"

      has_paper_trail(
        versions: { class_name: "Renalware::Clinical::Version" },
        on: %i(create update destroy)
      )

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :weight, presence: true, "renalware/patients/weight" => true
      validates :assessed_on, presence: true
      validates :assessed_on, timeliness: { type: :date, allow_blank: false }
      validates :minimum_weight,
                numericality: { less_than_or_equal_to: :maximum_weight },
                unless: -> { maximum_weight.blank? }
      validates :maximum_weight,
                numericality: { less_than_or_equal_to: :minimum_weigh_plus_max_range },
                unless: -> { minimum_weigh_plus_max_range.blank? }

      def self.policy_class = BasePolicy

      def self.latest
        ordered.first
      end

      def minimum_weigh_plus_max_range
        return unless minimum_weight

        minimum_weight + 90.0
      end
    end
  end
end
