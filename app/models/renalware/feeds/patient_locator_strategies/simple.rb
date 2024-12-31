module Renalware
  module Feeds
    module PatientLocatorStrategies
      # As used at KCH.
      # Really we need to revisit this to check if we should be using DOB or looking at any other
      # local_patient_id* columns
      class Simple
        pattr_initialize [:patient_identification!]

        def self.call(**)
          new(**).call
        end

        def call
          Patient.find_by(local_patient_id: patient_identification.internal_id)
        end
      end
    end
  end
end
