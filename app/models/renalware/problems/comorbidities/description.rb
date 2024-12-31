module Renalware
  module Problems
    module Comorbidities
      # In Renalware a comorbidity is the occurrence in a patient of a particular non-renal problem
      # with life-long implications (unlike a 'problem' which the patient could recover
      # from) - e.g. the fact that that the patient has, at some point, had a heart attack.
      # Dementia is another example. This model and the table behind it define the list of
      # possible comorbidities in Renalware. Each has a snomed code which is used when reporting
      # to the UKRDC.
      class Description < ApplicationRecord
        acts_as_paranoid # we never delete old descriptions
        alias archived? deleted?
        validates :name, presence: true, uniqueness: true
        validates :position, presence: true
        self.table_name = :problem_comorbidity_descriptions

        scope :ordered, -> { order(position: :asc, name: :asc) }
      end
    end
  end
end
