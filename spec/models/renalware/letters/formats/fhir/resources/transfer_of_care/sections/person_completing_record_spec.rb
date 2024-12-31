module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::PersonCompletingRecord do
        subject(:section) { described_class.new(args) }

        let(:args) { instance_double(Arguments, author_urn: author_urn, letter: nil) }
        let(:author_urn) { "urn:uuid:456" }

        it { expect(section.snomed_code).to eq("887231000000104") }
        it { expect(section.title).to eq("Person completing record") }
        it { expect(section.entries).to eq([{ reference: author_urn }]) }
        it { expect(section.call).not_to be_nil }
        it { expect(section.render?).to be(true) }
      end
    end
  end
end
