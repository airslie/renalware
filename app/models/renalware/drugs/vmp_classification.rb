module Renalware
  class Drugs::VMPClassification < ApplicationRecord
    belongs_to :drug
    belongs_to :form
    belongs_to :unit_of_measure
    belongs_to :route, class_name: "Medications::MedicationRoute"
  end
end
