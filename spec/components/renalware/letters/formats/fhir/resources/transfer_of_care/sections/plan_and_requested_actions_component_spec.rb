module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::PlanAndRequestedActionsComponent, type: :component do
      it do
        letter = nil
        render_inline(described_class.new(letter))

        expect(page).to have_content("PlanAndRequestedActionsComponent")
      end
    end
  end
end
