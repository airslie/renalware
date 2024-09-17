# frozen_string_literal: true

module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::InvestigationResultsComponent, type: :component do
      it do
        letter = nil
        render_inline(described_class.new(letter))
        expect(page).to have_content("Investigation Results")
      end
    end
  end
end
