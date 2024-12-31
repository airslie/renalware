module Renalware
  module Drugs
    describe DrugCodeToIdMap do
      subject(:map) { described_class.new }

      describe "#[](key)" do
        it "returns nil where no match" do
          create(:drug, code: "999")

          expect(map["123"]).to be_nil
        end

        it "returns id of drug withing a matching code" do
          drug = create(:drug, code: "123")

          expect(map["123"]).to eq(drug.id)
        end

        it "does not return drugs with a code of nil" do
          create(:drug, code: nil)

          expect(map[nil]).to be_nil
        end

        it "does not return drugs with a code of ''" do
          create(:drug, code: "")

          expect(map[""]).to be_nil
        end
      end
    end
  end
end
