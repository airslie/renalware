module Renalware
  module Medications
    module Delivery
      # Represents a prescription associated with for example a home_delivery print event.
      # Usually creating a home delivery prescriptions print event will mean we create a row for
      # drug types esa, immunosuppressant or both. In the future other drug types may be associated
      # with the printing of prescriptions for a particular provider, so while this approach seems
      # a bit overkill, being normalised like this (as opposed to just say storing the drug type ids
      # or their codes in an array on medication_delivery_events) is more flexible and also provides
      # more scope for reporting.
      class EventPrescription < ApplicationRecord
        belongs_to :event, class_name: "Delivery::Event"
        belongs_to :prescription, class_name: "Medications::Prescription"

        validates :event, presence: true
        validates :prescription, presence: true
      end
    end
  end
end
