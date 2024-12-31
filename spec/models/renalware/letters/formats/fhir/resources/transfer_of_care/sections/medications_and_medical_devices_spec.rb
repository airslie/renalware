module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::MedicationsAndMedicalDevices do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("933361000000108") }
        it { expect(section.title).to eq("Medications and medical devices") }
        it { expect(section.render?).to be(true) }
      end
    end
  end
end
