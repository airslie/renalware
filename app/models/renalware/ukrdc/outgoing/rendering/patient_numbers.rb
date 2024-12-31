module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class PatientNumbers < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            patient_numbers_element
          end

          private

          def patient_numbers_element
            create_node("PatientNumbers") do |patient_numbers|
              patient_numbers << nhs_number_element if patient.nhs_number.present?
              patient_numbers << hospital_number_element if first_hospital_number.present?
            end
          end

          def nhs_number_element
            Rendering::PatientNumber.new(
              number: patient.nhs_number,
              organisation: "NHS",
              type: "NI"
            ).xml
          end

          def hospital_number_element
            Rendering::PatientNumber.new(
              number: first_hospital_number,
              organisation: "LOCALHOSP",
              type: "MRN"
            ).xml
          end

          def first_hospital_number
            @first_hospital_number ||= patient.hospital_identifier&.id
            # @first_hospital_number || begin
            #   Renalware.config.patient_hospital_identifiers.values.each do |field|
            #     next if (number = patient.public_send(field)).blank?

            #     return number
            #   end
            # end
          end
        end
      end
    end
  end
end
