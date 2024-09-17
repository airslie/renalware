# frozen_string_literal: true

module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::ProblemsAndIssuesComponent, type: :component do
      it do
        letter = nil
        render_inline(described_class.new(letter))

        expect(page).to have_content("ProblemsAndIssuesComponent")
      end
    end
  end
end
