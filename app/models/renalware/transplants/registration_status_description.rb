module Renalware
  module Transplants
    class RegistrationStatusDescription < ApplicationRecord
      belongs_to :ukrdc_assessment_outcome,
                 class_name: "Renalware::UKRDC::Assessments::Outcome",
                 foreign_key: :ukrdc_assessment_outcome_code,
                 primary_key: :code,
                 optional: true
      scope :ordered, -> { order(position: :asc) }

      validates :name, presence: true

      def to_s = name
    end
  end
end
