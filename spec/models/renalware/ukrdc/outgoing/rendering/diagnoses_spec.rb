# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Diagnoses do
        include XmlSpecHelper

        it do
          patient = UKRDC::PatientPresenter.new(build_stubbed(:patient))
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Diagnoses/>
          XML

          xml = format_xml(described_class.new(patient: patient).xml)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end

# TODO: include these tests pulled frm the old build view spec

# describe "Diagnoses element" do
#   helper(Renalware::ApplicationHelper)
#   subject(:xml) { partial_content(presenter) }

#   let(:presenter) { Renalware::UKRDC::PatientPresenter.new(patient) }
#   let(:patient) { nil }

#   def partial_content(patient_presenter)
#     render(
#       partial: "renalware/api/ukrdc/patients/diagnoses.xml.builder",
#       locals: {
#         patient: patient_presenter,
#         builder: Builder::XmlMarkup.new
#       }
#     )
#   end

#   def build_stubbed_death_modality(patient)
#     death = build_stubbed(:modality_description, :death).becomes(
#       Renalware::Deaths::ModalityDescription
#     )
#     modality = build_stubbed(
#       :modality,
#       patient: patient,
#       description: death,
#       started_on: Time.zone.now
#     )
#     allow(patient).to receive(:current_modality).and_return(modality)
#   end

#   context "when the patient is deceased" do
#     context "when the patient has no first cause of death" do
#       let(:patient) do
#         build_stubbed(:patient) do |pat|
#           build_stubbed_death_modality(pat)
#         end
#       end

#       it { is_expected.not_to include("<CauseOfDeath>") }
#     end

#     context "when the patient has a first cause of death" do
#       let(:patient) do
#         build_stubbed(:patient, first_cause: build_stubbed(:cause_of_death)) do |pat|
#           build_stubbed_death_modality(pat)
#         end
#       end

#       it { is_expected.to include("<CauseOfDeath") }
#     end
#   end

#   describe "Cormobidity Diagnoses" do
#     context "when the patient has had a malignancy with an onset date recorded" do
#       let(:patient) do
#         create(:patient) do |pat|
#           create(
#             :renal_profile,
#             patient: Renalware::Renal.cast_patient(pat),
#             esrf_on: "2012-01-01",
#             document: {
#               comorbidities: {
#                 malignancy: {
#                   status: "yes",
#                   confirmed_on_year: "2018"
#                 }
#               }
#             }
#           )
#         end
#       end

#       it "adds an OnsetTime of Jan 1 on the 'confirmed_on_year'" do
#         is_expected.to include(<<-XML.squish.gsub("> <", "><"))
#           <Diagnosis>
#             <Diagnosis>
#               <CodingStandard>SNOMED</CodingStandard>
#               <Code>86049000</Code>
#               <Description>Malignancy</Description>
#             </Diagnosis>
#             <OnsetTime>2018-01-01T00:00:00+00:00</OnsetTime>
#           </Diagnosis>
#         XML
#       end
#     end

#     context "when the patient has had a malignancy with no onset date recorded" do
#       let(:patient) do
#         create(:patient) do |pat|
#           create(
#             :renal_profile,
#             patient: Renalware::Renal.cast_patient(pat),
#             esrf_on: "2012-02-02",
#             document: {
#               comorbidities: {
#                 malignancy: {
#                   status: "yes",
#                   confirmed_on_year: ""
#                 }
#               }
#             }
#           )
#         end
#       end

#       it "uses the esrf date as the IdentificationTime" do
#         is_expected.to include(<<-XML.squish.gsub("> <", "><"))
#           <Diagnosis>
#             <Diagnosis>
#               <CodingStandard>SNOMED</CodingStandard>
#               <Code>86049000</Code>
#               <Description>Malignancy</Description>
#             </Diagnosis>
#             <IdentificationTime>2012-02-02T00:00:00+00:00</IdentificationTime>
#           </Diagnosis>
#         XML
#       end
#     end

#     context "when the patient has had malignancy with no onset date recorded and no esrf date" do
#       let(:patient) do
#         create(:patient) do |pat|
#           create(
#             :renal_profile,
#             patient: Renalware::Renal.cast_patient(pat),
#             esrf_on: nil,
#             document: {
#               comorbidities: {
#                 malignancy: {
#                   status: "yes",
#                   confirmed_on_year: ""
#                 }
#               }
#             }
#           )
#         end
#       end

#       it "includes no IdentificationTime or OnsetTime" do
#         is_expected.to include(<<-XML.squish.gsub("> <", "><"))
#           <Diagnosis>
#             <Diagnosis>
#               <CodingStandard>SNOMED</CodingStandard>
#               <Code>86049000</Code>
#               <Description>Malignancy</Description>
#             </Diagnosis>
#           </Diagnosis>
#         XML
#       end
#     end
#   end

#   describe "RenalDiagnosis" do
#     context "when the patient has no Primary Renal Diagnosis (PRD)" do
#       let(:patient) { build_stubbed(:patient) }

#       it { is_expected.not_to include("<RenalDiagnosis") }
#     end

#     context "when the patient has a Primary Renal Diagnosis (PRD)" do
#       let(:patient) do
#         create(:patient) do |pat|
#           create(
#             :renal_profile,
#             first_seen_on: "2018-12-01",
#             patient: Renalware::Renal.cast_patient(pat),
#             prd_description: create(:prd_description, code: 111, term: "XXX")
#           )
#         end
#       end

#       it do
#         is_expected.to include(<<-XML.squish.gsub("> <", "><"))
#           <RenalDiagnosis>
#             <Diagnosis>
#               <CodingStandard>EDTA2</CodingStandard>
#               <Code>111</Code>
#               <Description>XXX</Description>
#             </Diagnosis>
#             <IdentificationTime>2018-12-01T00:00:00+00:00</IdentificationTime>
#           </RenalDiagnosis>
#         XML
#       end
#     end
#   end
# end
