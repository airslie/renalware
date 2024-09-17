# frozen_string_literal: true

module Renalware
  describe "renalware/letters/formatted_letters/_enclosures" do
    let(:partial) { "renalware/letters/formatted_letters/enclosures" }

    context "when the letter has enclosures" do
      it "outputs them" do
        letter = instance_double(Renalware::Letters::Letter, enclosures: "ABC, 123")

        render partial: partial, locals: { letter: letter }

        expect(rendered).to include("Enc: ABC, 123")
      end
    end

    context "when the letter does not have enclosures" do
      it "no enclosures are output" do
        letter = instance_double(Renalware::Letters::Letter, enclosures: "")

        render partial: partial, locals: { letter: letter }

        expect(rendered).not_to include("Enc:")
      end
    end
  end
end
