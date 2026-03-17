module Renalware
  module Deaths
    class Location < ApplicationRecord
      acts_as_paranoid
      belongs_to :ukrdc_assessment_outcome,
                 class_name: "Renalware::UKRDC::Assessments::Outcome",
                 foreign_key: :ukrdc_assessment_outcome_code,
                 primary_key: :code,
                 optional: true
      validates :name, presence: true, uniqueness: { case_sensitive: false }
      before_validation { self.name = name&.strip }
      scope :ordered, -> { order(:name) }

      def self.policy_class = BasePolicy
      def to_s = name
    end
  end
end
