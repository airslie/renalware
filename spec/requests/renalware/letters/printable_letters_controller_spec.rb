# frozen_string_literal: true

require "pdf/reader"

describe "Rendering a letter for printing in an envelope stuffer" do
  include LettersSpecHelper
  let(:user) { create(:user) }

  describe "GET show" do
    it "renders a duplex interleaved address+letter PDF" do
      letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact

      get patient_letters_letter_printable_path(
        patient_id: letter.patient,
        letter_id: letter,
        format: "pdf"
      )

      expect(response).to be_successful
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "#{letter.patient.family_name.upcase}-" \
                 "#{letter.patient.local_patient_id.upcase}-" \
                 "#{letter.id}-APPROVED.pdf"
      expect(response["Content-Disposition"]).to include("inline")
      expect(response["Content-Disposition"]).to include(filename)
    end
  end
end
