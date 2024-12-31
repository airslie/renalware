module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::Procedures do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("887171000000109") }
        it { expect(section.title).to eq("Procedures") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
