module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::ProblemsAndIssues do
        subject(:section) { described_class.new(args) }

        let(:args) { instance_double(Arguments, patient_urn: patient_urn, letter: nil) }
        let(:patient_urn) { "urn:uuid:234" }

        it do
          expect(section).to have_attributes(
            snomed_code: "887151000000100",
            title: "Problems and issues",
            entries: [{ reference: patient_urn }]
          )
        end

        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }
      end
    end
  end
end
