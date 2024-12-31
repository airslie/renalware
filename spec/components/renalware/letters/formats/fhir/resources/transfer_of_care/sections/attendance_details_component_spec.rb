module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::AttendanceDetailsComponent, type: :component do
      it do
        letter = instance_double(Renalware::Letters::Letter, salutation: "Dear X", body: "abc")
        render_inline(described_class.new(letter))

        expect(page).to have_content("Dear X")
        expect(page).to have_content("abc")
      end
    end
  end
end
