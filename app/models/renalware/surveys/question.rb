module Renalware
  module Surveys
    class Question < ApplicationRecord
      include PatientScope
      acts_as_paranoid
      belongs_to :survey
      has_many(
        :responses,
        class_name: "Response",
        dependent: :nullify
      )
      validates :code, presence: true, uniqueness: { scope: :survey_id }
      validates :label, presence: true
      validates :position, presence: true

      def admin_label
        label_abbrv.presence || label
      end
    end
  end
end
