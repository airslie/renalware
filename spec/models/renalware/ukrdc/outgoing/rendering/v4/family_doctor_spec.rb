module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::FamilyDoctor do
        include XmlSpecHelper

        context "when the patient has a practice" do
          it "renders it" do
            practice = build_stubbed(:practice, code: "ABC")
            patient = build_stubbed(:patient, practice:)

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <FamilyDoctor>
                <GPPracticeId>ABC</GPPracticeId>
              </FamilyDoctor>
            XML

            actual_xml = format_xml(described_class.new(patient:).xml)

            expect(actual_xml).to eq(expected_xml)
          end
        end

        context "when the patient has a GP" do
          it "renders it" do
            gp = build_stubbed(:primary_care_physician, code: "ABC")
            patient = build_stubbed(:patient, primary_care_physician: gp)

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <FamilyDoctor>
                <GPId>ABC</GPId>
              </FamilyDoctor>
            XML

            actual_xml = format_xml(described_class.new(patient:).xml)

            expect(actual_xml).to eq(expected_xml)
          end
        end
      end
    end
  end
end
