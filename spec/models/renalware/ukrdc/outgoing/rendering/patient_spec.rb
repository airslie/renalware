# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Patient do
        include XmlSpecHelper

        it do
          # exists
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
