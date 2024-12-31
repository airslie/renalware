module Renalware
  describe AddressValidator, type: :validator do
    describe "validate" do
      it "validates that a UK address has a postcode" do
        address = Address.new(street_1: "123 North St.", country: build(:united_kingdom))
        address.valid?

        expect(address.errors[:postcode]).to include("can't be blank for UK address")
      end

      it "validates that the postcode only contains alphanumeric characters and spaces" do
        ["ABC/123", "ABC.123", "TW20 8AR\\n", "\\tTW20 8AR"].each do |postcode|
          (address = Address.new(postcode: postcode)).valid?

          expect(address.errors[:postcode]).to include("contains unexpected characters")
        end

        [nil, "", "TW20 8AR", "SW1A 1AA", "SA63", "IM9 4EB", "IV274EG"].each do |postcode|
          (address = Address.new(postcode: postcode)).valid?

          expect(address.errors[:postcode]).to eq([])
        end
      end
    end
  end
end
