module Renalware
  module Letters
    module Formats::FHIR::Resources::TransferOfCare
      describe Sections::SocialContext do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("887051000000101") }
        it { expect(section.title).to eq("Social context") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
