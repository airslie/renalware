# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Printing
  describe RecipientAddressPagePdf do
    include LettersSpecHelper

    describe "#render" do
      it "generates a PDF" do
        letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact

        pdf = described_class.new(letter.main_recipient)

        expect(pdf.render).to start_with "%PDF-1.3"
        # pdf.render_file "/Users/tim/tmp/prawn.pdf"
      end
    end
  end
end
