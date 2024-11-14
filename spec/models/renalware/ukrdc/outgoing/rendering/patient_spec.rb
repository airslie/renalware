# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Patient do
        include XmlSpecHelper

        it "assigns the patient a renal_registry_id if the don't have one" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: nil)
          )

          expect(patient.renal_registry_id).to be_nil
          described_class.new(patient: patient).xml
          expect(patient.reload.renal_registry_id).not_to be_nil
        end

        it "the patient already has a renal_registry_id it does not change it" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: "123")
          )

          expect(patient.renal_registry_id).to be_present
          described_class.new(patient: patient).xml
          expect(patient.reload.renal_registry_id).to eq("123")
        end
      end
    end
  end
end

# TODO: include these tests from the old builder view spec
# it "includes the correctly formatted NHS number" do
#   patient = Renalware::UKRDC::PatientPresenter.new(
#     build(
#       :patient,
#       nhs_number: "9999999999",
#       sent_to_ukrdc_at: 1.year.ago
#     )
#   )
#   render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
#          locals: {
#            patient: patient,
#            builder: Builder::XmlMarkup.new
#          }

#   expect(rendered).to include("<Number>9999999999</Number>")
# end

# it "includes omits NHS number if patient has none" do
#   patient = Renalware::UKRDC::PatientPresenter.new(
#     build(
#       :patient,
#       nhs_number: nil,
#       sent_to_ukrdc_at: 1.year.ago,
#       local_patient_id: nil
#     )
#   )
#   render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
#          locals: {
#            patient: patient,
#            builder: Builder::XmlMarkup.new
#          }

#   expect(rendered).not_to include("<Number>")
# end

# it "outputs PrimaryLanguage" do
#   language = build_stubbed(:language, :english)
#   patient = Renalware::UKRDC::PatientPresenter.new(
#     build(
#       :patient,
#       sent_to_ukrdc_at: 1.year.ago,
#       language: language
#     )
#   )
#   render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
#          locals: {
#            patient: patient,
#            builder: Builder::XmlMarkup.new
#          }

#   expect(rendered).to include("<PrimaryLanguage>")
# end

# context "when the language is Other (ot)" do
#   it "does not output it" do
#     language = build_stubbed(:language, :other)
#     patient = Renalware::UKRDC::PatientPresenter.new(
#       build(
#         :patient,
#         sent_to_ukrdc_at: 1.year.ago,
#         language: language
#       )
#     )
#     render partial: "renalware/api/ukrdc/patients/patient.xml.builder",
#            locals: {
#              patient: patient,
#              builder: Builder::XmlMarkup.new
#            }

#     expect(rendered).not_to include("<PrimaryLanguage>")
#   end
# end
