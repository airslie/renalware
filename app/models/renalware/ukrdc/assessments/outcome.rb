module Renalware
  module UKRDC::Assessments
    class Outcome < ApplicationRecord
      validates :code, presence: true
      belongs_to :assessment_type,
                 class_name: "Renalware::UKRDC::Assessments::Type",
                 optional: false
    end
  end
end
