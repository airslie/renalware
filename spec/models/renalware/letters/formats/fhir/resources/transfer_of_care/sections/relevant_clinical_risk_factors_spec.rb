module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::RelevantClinicalRiskFactors do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("886821000000100") }
        it { expect(section.title).to eq("Relevant clinical risk factors") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
