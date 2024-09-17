# frozen_string_literal: true

module Renalware
  describe PD::BagType do
    it_behaves_like "a Paranoid model"

    it :aggregate_failures do
      is_expected.to respond_to(:glucose_strength)
      is_expected.to validate_presence_of :manufacturer
      is_expected.to validate_presence_of :description
      is_expected.to validate_presence_of :glucose_strength
    end

    it {
      is_expected.to(
        validate_numericality_of(:glucose_content)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(50)
      )
    }

    describe "full_description" do
      it "concatenates manufacturer and description values" do
        bag_type = build(:bag_type, manufacturer: "Acme", description: "Wunderdrug 2000")
        expect(bag_type.full_description).to eq("Acme Wunderdrug 2000")
      end
    end
  end
end
