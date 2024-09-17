# frozen_string_literal: true

module Renalware::Drugs
  describe DMDMigration::FormMigrator do
    let(:form) { create(:drug_form, name: "Capsule") }
    let(:drug) { create(:drug) }
    let(:prescription) { create(:prescription, drug: drug) }
    let(:match) { DMDMatch.create!(drug: drug, form_name: "Capsule") }

    before do
      form && prescription && match
    end

    context "when a form_name exists in the match table" do
      it "populates the newly added `form_id` based on a match from the match table" do
        described_class.new.call
        expect(prescription.reload.form_id).to eq form.id

        # Re-run -> shouldn't change anything or report an error
        described_class.new.call
        expect(prescription.reload.form_id).to eq form.id
      end
    end
  end
end
