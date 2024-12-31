module Renalware
  describe Gender, type: :model do
    describe "validating the gender code" do
      it "is valid given a known code" do
        valid_gender = described_class.new("F")

        expect(valid_gender).to be_valid
      end

      it "is invalid given a unknown code" do
        valid_gender = described_class.new("X")

        expect(valid_gender).not_to be_valid
        expect(valid_gender.errors[:code]).to include(/included/)
      end

      it "is invalid given a no code" do
        valid_gender = described_class.new("")

        expect(valid_gender).not_to be_valid
        expect(valid_gender.errors[:code]).to include(/included/)
      end

      describe "#nhs_dictionary_number" do
        it "maps genders to the the correct NHS-defined number" do
          expect(described_class.new("NK").nhs_dictionary_number).to eq(0)
          expect(described_class.new("M").nhs_dictionary_number).to eq(1)
          expect(described_class.new("F").nhs_dictionary_number).to eq(2)
          expect(described_class.new("NS").nhs_dictionary_number).to eq(9)
        end
      end
    end
  end
end
