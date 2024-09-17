# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::InvestigationResults do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1082101000000102") }
        it { expect(section.title).to eq("Investigation results") }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil } # not supported yet
      end
    end
  end
end
