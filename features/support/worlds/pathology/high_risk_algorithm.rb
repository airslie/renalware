module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands
        #
        def run_high_risk_algorithm(patient)
          pathology_patient = Renalware::Pathology.cast_patient(patient)

          Renalware::Pathology::Requests::HighRiskAlgorithm.new(
            pathology_patient
          ).patient_is_high_risk?
        end
      end
    end
  end
end
