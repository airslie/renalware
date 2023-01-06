# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Address do
    describe ".uk?" do
      it "responds with true if the country is in the UK" do
        expect(Address.new(country: build(:united_kingdom))).to be_uk
      end

      it "responds with false country is missing" do
        expect(Address.new(country: nil)).not_to be_uk
      end

      it "responds with false country is not in the UK" do
        expect(Address.new(country: build(:algeria))).not_to be_uk
      end
    end

    describe ".street" do
      context "when all street attributes are present" do
        it "concatenates all street attributes into a comma delimited string" do
          address = Address.new(street_1: "S1", street_2: "S2", street_3: "S3")

          expect(address.street).to eq("S1, S2, S3")
        end
      end

      context "when some street attributes are missing" do
        it "concatenates non-blank street attributes into a comma delimited string" do
          address = Address.new(street_1: "", street_2: "S2", street_3: nil)

          expect(address.street).to eq("S2")
        end
      end
    end
  end
end
