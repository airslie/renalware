# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::InformationAndAdviceGiven do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("1052951000000105") }
        it { expect(section.title).to eq("Information and advice given") }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil } # section not supported
      end
    end
  end
end
