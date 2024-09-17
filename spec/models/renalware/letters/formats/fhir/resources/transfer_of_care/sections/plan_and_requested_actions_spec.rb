# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::PlanAndRequestedActions do
        subject(:section) { described_class.new(nil) }

        it { expect(section.snomed_code).to eq("887201000000105") }
        it { expect(section.title).to eq("Plan and requested actions") }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }
      end
    end
  end
end
