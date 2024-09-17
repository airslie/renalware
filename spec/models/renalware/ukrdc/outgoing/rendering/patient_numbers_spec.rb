# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::PatientNumbers do
        include XmlSpecHelper

        it "renders the NHS number if present" do
          patient = Patient.new(nhs_number: "9999999999")
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumbers>
              <PatientNumber>
                <Number>9999999999</Number>
                <Organization>NHS</Organization>
                <NumberType>NI</NumberType>
              </PatientNumber>
            </PatientNumbers>
          XML

          actual_xml = format_xml(described_class.new(patient: patient).xml)

          expect(actual_xml).to eq(expected_xml)
        end

        it "renders the first hospital number if present" do
          patient = Patient.new(local_patient_id: "", local_patient_id_2: "123")

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumbers>
              <PatientNumber>
                <Number>123</Number>
                <Organization>LOCALHOSP</Organization>
                <NumberType>MRN</NumberType>
              </PatientNumber>
            </PatientNumbers>
          XML

          actual_xml = format_xml(described_class.new(patient: patient).xml)

          expect(actual_xml).to eq(expected_xml)
        end
      end
    end
  end
end
# if patient.nhs_number.present?
#   xml.PatientNumber do
#     xml.Number patient.nhs_number
#     xml.Organization "NHS"
#     xml.NumberType "NI"
#   end
# end

# Renalware.config.patient_hospital_identifiers.values.each do |field|
#   next if (number = patient.public_send(field)).blank?

#   xml.PatientNumber do
#     xml.Number number
#     xml.Organization "LOCALHOSP"
#     xml.NumberType "MRN"
#   end
#   break
# end
# end
