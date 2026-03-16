module Renalware
  module UKRDC
    module Outgoing::Rendering::V4
      describe Assessments do
        include XmlSpecHelper

        let(:start_date) { 1.day.ago.to_date }
        let(:end_date) { Time.zone.today }
        let(:by) { create(:user, :minimal) }
        let(:ukrdc_outcome_unsuitable) { create(:ukrdc_assessment_outcome, :tx_unsuitable) }
        let(:ukrdc_outcome_suitable) { create(:ukrdc_assessment_outcome, :tx_suitable) }

        describe "preferred place of death assessment" do
          context "when the patient has a preferred death location" do
            it "renders an Assessment for it" do
              location = create(:death_location, :home)
              patient = create(:patient, preferred_death_location: location, by:)

              expected_xml = <<~XML.squish.gsub("> <", "><")
                <Assessments>
                  <Assessment>
                    <AssessmentType>
                      <CodingStandard>RR50</CodingStandard>
                      <Code>PPDassess</Code>
                      <Description>Preferred place of dying</Description>
                    </AssessmentType>
                    <AssessmentOutcome>
                      <CodingStandard>RR51</CodingStandard>
                      <Code>11</Code>
                      <Description>Current home</Description>
                    </AssessmentOutcome>
                  </Assessment>
                </Assessments>
              XML

              actual_xml = format_xml(described_class.new(patient:).xml)

              expect(actual_xml).to match_xml(expected_xml)
            end
          end

          context "when the patient has no relevant assessments" do
            it "renders Assessments with no Assessment children" do
              patient = create(:patient, preferred_death_location: nil, by:)
              expected_xml = "<Assessments/>"

              actual_xml = format_xml(described_class.new(patient:).xml)

              expect(actual_xml).to match_xml(expected_xml)
            end
          end
        end

        describe "AKCC assessment" do
          context "when the patient has no akcc_profile" do
            it "renders Assessments with no Assessment children" do
              patient = create(:patient, preferred_death_location: nil, by:)
              expected_xml = "<Assessments/>"

              actual_xml = format_xml(described_class.new(patient:).xml)

              expect(actual_xml).to match_xml(expected_xml)
            end
          end

          it "renders an Assessment for the patient's dialysis plan" do
            create(:ukrdc_assessment_outcome, :hd)
            patient = create(:low_clearance_patient)
            dialysis_plan = create(
              :low_clearance_dialysis_plan,
              :hd,
              ukrdc_assessment_outcome_code: 7
            )
            patient.create_profile!(dialysis_plan:, by:)

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <Assessments>
                <Assessment>
                  <AssessmentStart>#{dialysis_plan.created_at.to_date.to_datetime.iso8601}</AssessmentStart>
                  <AssessmentType>
                    <CodingStandard>RR50</CodingStandard>
                    <Code>RRTassess</Code>
                    <Description>Shared future RRT choice</Description>
                  </AssessmentType>
                  <AssessmentOutcome>
                    <CodingStandard>RR51</CodingStandard>
                    <Code>7</Code>
                    <Description>Opts for ICHD</Description>
                  </AssessmentOutcome>
                </Assessment>
              </Assessments>
            XML

            actual_xml = format_xml(described_class.new(patient:).xml)

            expect(actual_xml).to match_xml(expected_xml)
          end
        end

        describe "Tx registration assessments" do
          context "when the patient has no Tx registrations" do
            it "renders Assessments with no Assessment children" do
              patient = create(:patient, preferred_death_location: nil, by:)
              expected_xml = "<Assessments/>"

              actual_xml = format_xml(described_class.new(patient:).xml)

              expect(actual_xml).to match_xml(expected_xml)
            end
          end

          def create_tx_reg_status(registration:, description_trait:, ukrdc_outcome:, started_on:)
            description = create(
              :transplant_registration_status_description,
              description_trait,
              ukrdc_assessment_outcome: ukrdc_outcome
            )
            create(
              :transplant_registration_status,
              started_on:,
              description:,
              registration:,
              by:
            )
          end

          # rubocop:disable RSpec/ExampleLength
          it "renders Assessments for the patient's Tx registrations" do
            patient = create(:transplant_patient, by:)
            registration = create(:transplant_registration, patient:)

            status_suitable = create_tx_reg_status(
              registration:,
              description_trait: :active,
              ukrdc_outcome: ukrdc_outcome_suitable,
              started_on: 1.day.ago.to_date
            )
            status_unsuitable = create_tx_reg_status(
              registration:,
              description_trait: :active,
              ukrdc_outcome: ukrdc_outcome_unsuitable,
              started_on: 1.month.ago.to_date
            )

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <Assessments>
                <Assessment>
                  <AssessmentStart>#{status_unsuitable.started_on.to_datetime.iso8601}</AssessmentStart>
                  <AssessmentType>
                    <CodingStandard>RR50</CodingStandard>
                    <Code>TPLTassess</Code>
                    <Description>Suitability for renal transplant</Description>
                  </AssessmentType>
                  <AssessmentOutcome>
                    <CodingStandard>RR51</CodingStandard>
                    <Code>1</Code>
                    <Description>Unsuitable</Description>
                  </AssessmentOutcome>
                </Assessment>
                <Assessment>
                  <AssessmentStart>#{status_suitable.started_on.to_datetime.iso8601}</AssessmentStart>
                  <AssessmentType>
                    <CodingStandard>RR50</CodingStandard>
                    <Code>TPLTassess</Code>
                    <Description>Suitability for renal transplant</Description>
                  </AssessmentType>
                  <AssessmentOutcome>
                    <CodingStandard>RR51</CodingStandard>
                    <Code>3</Code>
                    <Description>Suitable</Description>
                  </AssessmentOutcome>
                </Assessment>
              </Assessments>
            XML

            actual_xml = format_xml(described_class.new(patient:).xml)

            expect(actual_xml).to match_xml(expected_xml)
          end
          # rubocop:enable RSpec/ExampleLength
        end
      end
    end
  end
end
