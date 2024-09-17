# frozen_string_literal: true

module Renalware
  module Problems
    # An instance of a single patient comorbidity problem eg 'Dementia' (defined by the
    # :description) a boolean #recognised value (true = Yes, false = No, null = unknown) and
    # the date of recognition. While some comorbidity problems (e.g heart attack) have a resolvable
    # recognition date, many (e.g. dementia) do not, so it is fine for a clinician to enter e.g.
    # 1 Jan 2020 when dementia was recognised during that year.
    # See Comorbidities::Description for more information.
    class Comorbidity < ApplicationRecord
      include Accountable

      has_paper_trail(
        versions: { class_name: "Renalware::Problems::Version" },
        on: [:create, :update, :destroy]
      )

      belongs_to :patient
      belongs_to :malignancy_site
      belongs_to :description, class_name: "Comorbidities::Description"

      validates :patient, presence: true
      validates :description, presence: true, uniqueness: { scope: :patient_id }

      scope :ordered, lambda {
        includes(:description)
          .order("#{Comorbidities::Description.table_name}.position")
      }
      scope :at_date, ->(date) { where("recognised_at <= ?", date) }

      def self.policy_class = BasePolicy
    end
  end
end
