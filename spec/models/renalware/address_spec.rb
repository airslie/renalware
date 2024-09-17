# frozen_string_literal: true

module Renalware
  describe Address do
    describe ".uk?" do
      it "responds with true if the country is in the UK" do
        expect(described_class.new(country: build(:united_kingdom))).to be_uk
      end

      it "responds with false country is missing" do
        expect(described_class.new(country: nil)).not_to be_uk
      end

      it "responds with false country is not in the UK" do
        expect(described_class.new(country: build(:algeria))).not_to be_uk
      end
    end

    describe ".street" do
      context "when all street attributes are present" do
        it "concatenates all street attributes into a comma delimited string" do
          address = described_class.new(street_1: "S1", street_2: "S2", street_3: "S3")

          expect(address.street).to eq("S1, S2, S3")
        end
      end

      context "when some street attributes are missing" do
        it "concatenates non-blank street attributes into a comma delimited string" do
          address = described_class.new(street_1: "", street_2: "S2", street_3: nil)

          expect(address.street).to eq("S2")
        end
      end
    end

    describe "Uppercasing postcode before validation" do
      it "does nothing if postcode is nil" do
        address = build(:address, postcode: nil)
        address.valid?
        expect(address.postcode).to be_nil
      end

      it "does nothing if postcode is ''" do
        address = build(:address, postcode: "")
        address.valid?

        expect(address.postcode).to eq("")
      end

      it "converts a lower case postcode to uppercase" do
        address = build(:address, postcode: "abc xyz")
        address.valid?

        expect(address.postcode).to eq("ABC XYZ")
      end
    end
  end
end
