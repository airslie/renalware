module Renalware
  module Letters
    module Formats::FHIR::Resources::TransferOfCare
      describe Sections::ClinicalReviewOfSystems do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1077901000000108") }
        it { expect(section.title).to eq("Clinical review of systems") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
