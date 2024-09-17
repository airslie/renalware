# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Patient < Rendering::Base
          pattr_initialize [:patient!]

          # rubocop:disable Metrics/AbcSize
          def xml
            create_node("ukrdc:PatientRecord") do |ukrdc_patient_elem|
              ukrdc_patient_elem["xmlns:ukrdc"] = "http://www.rixg.org.uk/"
              ukrdc_patient_elem["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
              ukrdc_patient_elem << sending_facility_element # test
              ukrdc_patient_elem << sending_extract_element # test
              ukrdc_patient_elem << create_node("Patient") do |patient_elem|
                patient_elem << patient_numbers_element
                patient_elem << names_element
                patient_elem << born_on_element
                patient_elem << death_time_element
                patient_elem << gender_element
                patient_elem << addresses_element
                patient_elem << family_doctor_element
                patient_elem << ethnic_group_element
                patient_elem << primary_language_element # test
                patient_elem << death_element
                patient_elem << create_node("UpdatedOn", patient.updated_at&.to_datetime)
                # patient_elem << create_node("ActionCode", "A")
                patient_elem << create_node("ExternalId", patient.ukrdc_external_id)
              end
              ukrdc_patient_elem << lab_orders_element
              ukrdc_patient_elem << observations_element
              ukrdc_patient_elem << diagnoses_element
              ukrdc_patient_elem << medications_element
              ukrdc_patient_elem << procedures_element
              ukrdc_patient_elem << documents_element
              ukrdc_patient_elem << encounters_element
              ukrdc_patient_elem << opt_outs_element
            end
          end
          # rubocop:enable Metrics/AbcSize

          private

          def opt_outs_element
            ukrr_opt_out_element = Rendering::OptOut.new(patient: patient).xml
            if ukrr_opt_out_element
              create_node("OptOuts") { |opt_outs| opt_outs << ukrr_opt_out_element }
            end
          end

          def sending_facility_element
            create_node("SendingFacility", Renalware.config.ukrdc_sending_facility_name) do |fac|
              fac[:channelName] = "Renalware #{Renalware::VERSION}"
              fac[:schemaVersion] = Renalware.config.ukrdc_schema_version
              fac[:time] = Time.zone.now.to_datetime.change(sec: 0)
            end
          end

          def sending_extract_element
            create_node("SendingExtract", "UKRDC")
          end

          def names_element
            create_node("Names") do |names|
              names << Rendering::Name.new(nameable: patient).xml
            end
          end

          def addresses_element
            address = patient.current_address
            return if address.blank?

            create_node("Addresses") do |addresses|
              addresses << Rendering::Address.new(address: address).xml
            end
          end

          def patient_numbers_element
            Rendering::PatientNumbers.new(patient: patient).xml
          end

          def born_on_element
            create_node("BirthTime", patient.born_on.to_datetime)
          end

          def death_time_element
            if patient.dead? && patient.died_on.present?
              create_node("DeathTime", patient.died_on.to_datetime)
            end
          end

          def gender_element
            create_node("Gender", patient.sex&.nhs_dictionary_number)
          end

          def ethnic_group_element
            return if patient.ethnicity.blank?

            create_node("EthnicGroup") do |elem|
              elem << create_node("CodingStandard", "NHS_DATA_DICTIONARY")
              elem << create_node("Code", patient.ethnicity&.rr18_code)
            end
          end

          def family_doctor_element
            Rendering::FamilyDoctor.new(patient: patient).xml
          end

          def primary_language_element
            Rendering::PrimaryLanguage.new(patient: patient).xml
          end

          def death_element
            create_node("Death", true) if patient.dead?
          end

          def lab_orders_element
            LabOrders.new(patient: patient).xml
          end

          def medications_element
            create_node("Medications") do |medications_element|
              patient.prescriptions_with_numeric_dose_amount.each do |prescription|
                medications_element << Rendering::Medication.new(prescription: prescription).xml
              end
            end
          end

          def observations_element
            Rendering::Observations.new(patient: patient).xml
          end

          def documents_element
            return unless Renalware.config.ukrdc_include_letters

            create_node("Documents") do |documents_element|
              patient.letters.each do |letter|
                documents_element << Rendering::Document.new(letter: letter).xml
              end
            end
          end

          def procedures_element
            Rendering::Procedures.new(patient: patient).xml
          end

          def diagnoses_element
            Rendering::Diagnoses.new(patient: patient).xml
          end

          # Treatments (modalities in RW parlance) are put under the Encounters element.
          # Treatments are generated during the export process - see GenerateTimeline.
          # We derive the name of a Treatment class eg "HD Treatment" to handle the rendering of
          # the treatment, and if the class does not exist we just use the base Treatment class.
          def encounters_element
            create_node("Encounters") do |elem|
              patient.treatments.each do |treatment|
                klass = treatment_class_for(treatment.modality_description)
                elem << klass.new(treatment: treatment).xml
              end
            end
          end

          def treatment_class_for(modality_description)
            namespace = modality_description.namespace_raw # e.g. HD
            Renalware::UKRDC::Outgoing::Rendering.const_get("#{namespace}Treatment")
          rescue NameError
            Rendering::Treatment
          end
        end
      end
    end
  end
end
