module Renalware
  module Pathology
    module Requests
      class PatientAlgorithm
        def initialize(patient, date: Date.current)
          @patient = patient
          @date = date
        end

        def determine_required_tests
          @patient.rules.select { |rule| rule.required?(@date) }
        end
      end
    end
  end
end
