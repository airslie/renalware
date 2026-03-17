# TODO: when updating the UI, remember to use the 'with_deleted' scope so that
# if a plan is soft-deleted, it will still be displayed in low_clearance profiles that
# reference it, even though the plan will not be available for selection prospectively.
module Renalware
  module LowClearance
    class DialysisPlan < ApplicationRecord
      acts_as_paranoid
      belongs_to :ukrdc_assessment_outcome,
                 class_name: "Renalware::UKRDC::Assessments::Outcome",
                 foreign_key: :ukrdc_assessment_outcome_code,
                 primary_key: :code,
                 optional: true
      validates :code, presence: true
      validates :name, presence: true
    end
  end
end
