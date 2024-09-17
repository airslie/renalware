# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Medication do
        include XmlSpecHelper

        # TODO: use build
        def create_prescription_for(patient, dose_amount: "99", prescribed_on: 1.week.ago)
          drug = create(:drug, name: "Drug1")
          route = create(:medication_route, code: "Route1", name: "Route1")
          create(
            :prescription,
            patient: patient,
            drug: drug,
            frequency: "daily",
            dose_amount: dose_amount,
            dose_unit: "milligram",
            medication_route: route,
            prescribed_on: prescribed_on
          )
        end

        def create_terminated_prescription(patient, terminated_on:, **)
          terminated_prescription = create_prescription_for(patient, **)
          terminated_prescription.terminate(by: create(:user), terminated_on: terminated_on).save!
          terminated_prescription
        end

        context "when the drug is active" do
          it do
            active_prescription = create_prescription_for(
              create(:patient),
              dose_amount: "99",
              prescribed_on: 1.week.ago
            )

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <Medication>
                <FromTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
                <EnteringOrganization>
                  <CodingStandard>ODS</CodingStandard>
                  <Code>RJZ</Code>
                </EnteringOrganization>
                <Route>
                  <CodingStandard>RR22</CodingStandard>
                  <Code>1</Code>
                </Route>
                <DrugProduct>
                  <Generic>Drug1</Generic>
                </DrugProduct>
                <Frequency>daily</Frequency>
                <Comments>99 mg daily</Comments>
                <DoseQuantity>99</DoseQuantity>
                <DoseUoM>
                  <CodingStandard>LOCAL</CodingStandard>
                  <Code>mg</Code>
                  <Description>milligram</Description>
                </DoseUoM>
                <ExternalId>#{active_prescription.id}</ExternalId>
              </Medication>
            XML

            actual_xml = format_xml(described_class.new(prescription: active_prescription).xml)

            expect(actual_xml).to eq(expected_xml)
          end

          context "when the drug is terminated" do
            it do
              terminated_prescription = create_terminated_prescription(
                create(:patient),
                dose_amount: "98",
                prescribed_on: 2.weeks.ago,
                terminated_on: 1.week.ago
              )

              expected_xml = <<~XML.squish.gsub("> <", "><")
                <Medication>
                  <FromTime>#{2.weeks.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
                  <ToTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</ToTime>
                  <EnteringOrganization>
                    <CodingStandard>ODS</CodingStandard>
                    <Code>RJZ</Code>
                  </EnteringOrganization>
                  <Route>
                    <CodingStandard>RR22</CodingStandard>
                    <Code>1</Code>
                  </Route>
                  <DrugProduct>
                    <Generic>Drug1</Generic>
                  </DrugProduct>
                  <Frequency>daily</Frequency>
                  <Comments>98 mg daily</Comments>
                  <DoseQuantity>98</DoseQuantity>
                  <DoseUoM>
                    <CodingStandard>LOCAL</CodingStandard>
                    <Code>mg</Code>
                    <Description>milligram</Description>
                  </DoseUoM>
                  <ExternalId>#{terminated_prescription.id}</ExternalId>
                </Medication>
              XML

              actual_xml = format_xml(
                described_class.new(prescription: terminated_prescription).xml
              )

              expect(actual_xml).to eq(expected_xml)
            end
          end
        end
      end
    end
  end
end

# TODO: add these tests copied from the old builder view spec
#
# context "when the patient has a medication with a numeric dose amount" do
#   it "includes a Medication element omitting the DoseQuantity" do
#     patient = create(:patient)
#     presenter = Renalware::UKRDC::PatientPresenter.new(patient)
#     create_prescription_for(patient, dose_amount: "> 99")

#     xml = partial_content(presenter)

#     expect(xml).not_to include("<DoseQuantity>")
#   end
# end
