module Renalware::Feeds::HL7Segments
  describe NK1 do
    subject(:nk1) { Renalware::Feeds::MessageParser.parse(raw_message).nk1.first }

    let(:raw_message) do
      "NK1|1|DOE^JOHN^A^CBE^MR^JR^^^|SPO^SPOUSE|address1^address2|phone|business-phone||Y|"
    end

    describe "#to_fs" do
      context 'when there the address contains "' do
        let(:raw_message) do
          'NK1|1|DOE^JOHN^A^CBE^""^""^^^|SPO^SPOUSE|address1^""|phone|""||Y|'
        end

        it "removes them" do
          expect(nk1.to_fs).to eq(
            "SPO SPOUSE\nJOHN DOE CBE\nphone\naddress1"
          )
        end
      end

      describe "with missing fields" do
        let(:raw_message) { "NK1|1|DOE^JOHN^A^^^^^^|||||||" }

        it do
          expect(nk1.to_fs).to eq("JOHN DOE")
        end
      end

      describe 'with "" in values fields' do
        let(:raw_message) { 'NK1|1|DOE^JOHN^A^""^""^""^""^""^|||||||' }

        it do
          expect(nk1.to_fs).to eq("JOHN DOE")
        end
      end

      describe "with no fields" do
        let(:raw_message) { "NK1|1|||||||||||" }

        it do
          expect(nk1.to_fs).to eq("")
        end
      end
    end
  end
end
