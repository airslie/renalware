# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe "renalware/letters/formatted_letters/_enclosures", type: :view do
    let(:partial) { "renalware/letters/formatted_letters/enclosures" }

    context "when the letter has enclsoures" do
      it "outputs them" do
        letter = instance_double(Renalware::Letters::Letter, enclosures: "ABC, 123")

        render partial: partial, locals: { letter: letter }

        expect(rendered).to include("Enc: ABC, 123")
      end
    end

    context "when the letter does not have enclsoures" do
      it "no ennclures are output" do
        letter = instance_double(Renalware::Letters::Letter, enclosures: "")

        render partial: partial, locals: { letter: letter }

        expect(rendered).not_to include("Enc:")
      end
    end
  end
end
