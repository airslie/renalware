# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR::Resources::TransferOfCare
      describe Sections::SafetyAlerts do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("886931000000107") }
        it { expect(section.title).to eq("Safety alerts") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
