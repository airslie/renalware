module Renalware
  module UKRDC::Assessments
    # Value object to represent an assessment for the purposes of rendering UKRDC XML.
    # This is not intended to be persisted.
    class Type < ApplicationRecord
      validates :code, presence: true
      has_many :outcomes,
               class_name: "Renalware::UKRDC::Assessments::Outcome",
               foreign_key: :assessment_type_id,
               inverse_of: :assessment_type,
               dependent: :destroy
    end
  end
end
