module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Diagnoses < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            diagnoses_element
          end

          private

          def diagnoses_element
            create_node("Diagnoses") do |elem|
              create_comorbidity_diagnoses_inside(elem)
              elem << smoking_diagnosis_element
              elem << cause_of_death_element
              elem << renal_diagnosis_element
            end
          end

          # See email from GS to TC 23/5/18 regarding dates.
          # UKRDC would like to receive a date so if no onset date stored in RW for the
          # comorbidity, send the esrf date as the identification date
          def create_comorbidity_diagnoses_inside(elem)
            patient.yes_comorbidities.each do |comorb|
              options = { coding_standard: "SNOMED", code: comorb.code, description: comorb.name }
              if comorb.date.present?
                options[:onset_time] = comorb.date
              elsif patient.esrf_on.present?
                options[:identification_time] = patient.esrf_on
              end
              elem << Rendering::Diagnosis.new(options).xml
            end
          end

          def smoking_diagnosis_element
            return if patient.smoking_cormbidity&.value.blank?

            diagnosis = Rendering::Diagnosis.new(
              coding_standard: "SNOMED",
              code: patient.smoking_cormbidity.snomed_code,
              description: "Smoking history: #{patient.smoking_cormbidity.snomed_description}"
            )
            diagnosis.identification_time = patient.esrf_on if patient.esrf_on.present?
            diagnosis.xml
          end

          def cause_of_death_element
            Rendering::CauseOfDeath.new(patient: patient).xml
          end

          def renal_diagnosis_element
            Rendering::RenalDiagnosis.new(patient: patient).xml
          end
        end
      end
    end
  end
end
