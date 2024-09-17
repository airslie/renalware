# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::ParticipationInResearch do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("886751000000102") }
        it { expect(section.title).to eq("Participation in research") }
        it { expect(section.render?).to be(false) }
        it { expect(section.call).to be_nil } # section not supported
      end
    end
  end
end
