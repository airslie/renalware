module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::FamilyHistory do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("887111000000104") }
        it { expect(section.title).to eq("Family history") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
