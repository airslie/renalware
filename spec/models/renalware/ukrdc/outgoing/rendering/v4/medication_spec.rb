module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::Medication do
        include XmlSpecHelper

        let(:uom) { create(:drug_unit_of_measure, :mg) }
        let(:ukrdc_mg) { create(:ukrdc_measurement_unit, :mg) }

        before do
          ukrdc_mg
          allow(Renalware.config).to receive(:ukrdc_site_code).and_return("XXX")
        end

        # TODO: use build
        def create_prescription_for(patient, dose_amount: "99", prescribed_on: 1.week.ago)
          drug = create(:drug, name: "Drug1", code: "DM+D-123")
          route = create(:medication_route, code: "Route1", name: "Route1")
          create(
            :prescription,
            patient:,
            drug:,
            frequency: "daily",
            dose_amount:,
            unit_of_measure: uom,
            medication_route: route,
            prescribed_on:
          )
        end

        def create_terminated_prescription(patient, terminated_on:, **)
          terminated_prescription = create_prescription_for(patient, **)
          terminated_prescription.terminate(by: create(:user), terminated_on:).save!
          terminated_prescription
        end

        context "when the drug is active" do
          context "when dmd uom can be mapped to a UKRDC one" do
            it "includes the UKRDC UOM in a DoseUoM elem and unmapped dmd uom name in Comments" do
              active_prescription = create_prescription_for(
                create(:patient),
                dose_amount: "99",
                prescribed_on: 1.week.ago
              )

              # Note UKRDC use the same dmd code 'mg' but another description 'milligrams'.
              expected_xml = <<~XML.squish.gsub("> <", "><")
                <Medication>
                  <FromTime>#{1.week.ago.to_date.iso8601}T00:00:00+00:00</FromTime>
                  <EnteringOrganization>
                    <CodingStandard>ODS</CodingStandard>
                    <Code>XXX</Code>
                  </EnteringOrganization>
                  <Route>
                    <CodingStandard>RR22</CodingStandard>
                    <Code>1</Code>
                  </Route>
                  <DrugProduct>
                    <Id>
                      <CodingStandard>DM+D</CodingStandard>
                      <Code>DM+D-123</Code>
                      <Description>Drug1</Description>
                    </Id>
                    <Generic>Drug1</Generic>
                  </DrugProduct>
                  <Frequency>daily</Frequency>
                  <Comments>99 mg daily</Comments>
                  <DoseQuantity>99</DoseQuantity>
                  <DoseUoM>
                    <CodingStandard>CF_RR23</CodingStandard>
                    <Code>mg</Code>
                    <Description>milligrams</Description>
                  </DoseUoM>
                  <ExternalId>#{active_prescription.id}</ExternalId>
                </Medication>
              XML

              actual_xml = format_xml(described_class.new(prescription: active_prescription).xml)

              expect(actual_xml).to eq(expected_xml)
            end

            context "when prescription's dmd unit of measure cannot be mapped to a UKRDC one" do
              let(:uom) { create(:drug_unit_of_measure, name: "kg") }

              it "omits DoseUoM element and includes the dmd uom in the Comments" do
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
                      <Code>XXX</Code>
                    </EnteringOrganization>
                    <Route>
                      <CodingStandard>RR22</CodingStandard>
                      <Code>1</Code>
                    </Route>
                    <DrugProduct>
                      <Id>
                        <CodingStandard>DM+D</CodingStandard>
                        <Code>DM+D-123</Code>
                        <Description>Drug1</Description>
                      </Id>
                      <Generic>Drug1</Generic>
                    </DrugProduct>
                    <Frequency>daily</Frequency>
                    <Comments>99 kg daily</Comments>
                    <DoseQuantity>99</DoseQuantity>
                    <ExternalId>#{active_prescription.id}</ExternalId>
                  </Medication>
                XML

                actual_xml = format_xml(described_class.new(prescription: active_prescription).xml)

                expect(actual_xml).to eq(expected_xml)
              end
            end
          end

          context "when the drug is terminated" do
            it do # rubocop:disable RSpec/ExampleLength
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
                    <Code>XXX</Code>
                  </EnteringOrganization>
                  <Route>
                    <CodingStandard>RR22</CodingStandard>
                    <Code>1</Code>
                  </Route>
                  <DrugProduct>
                    <Id>
                      <CodingStandard>DM+D</CodingStandard>
                      <Code>DM+D-123</Code>
                      <Description>Drug1</Description>
                    </Id>
                    <Generic>Drug1</Generic>
                  </DrugProduct>
                  <Frequency>daily</Frequency>
                  <Comments>98 mg daily</Comments>
                  <DoseQuantity>98</DoseQuantity>
                  <DoseUoM>
                    <CodingStandard>CF_RR23</CodingStandard>
                    <Code>mg</Code>
                    <Description>milligrams</Description>
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
