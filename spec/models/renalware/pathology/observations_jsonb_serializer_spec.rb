# frozen_string_literal: true

module Renalware
  module Pathology
    describe ObservationsJsonbSerializer do
      let(:hgb) { { "result" => "23.1", "observed_at" => "2017-12-12 01:01:01" } }

      describe "dynamic OBX methods via method missing" do
        it "allows retrieval of the observation hash via a method with the name of the OBX code" do
          allow(AllObservationCodes.instance).to receive(:all).twice.and_return([:HGB])

          hash = described_class.load(HGB: hgb)

          expect(hash.hgb).to eq(hgb)
          expect(hash.HGB).to eq(hgb)
          expect(AllObservationCodes.instance).to have_received(:all).twice
        end

        it "allows accessing OBX result via the code" do
          hash = described_class.load(HGB: hgb)

          expect(hash.hgb_result).to eq(hgb["result"])
        end

        it "allows accessing OBX date via the code" do
          hash = described_class.load(HGB: hgb)

          expect(hash.hgb_observed_at).to eq(Date.parse(hgb["observed_at"]))
        end

        context "when the code does not exist" do
          it "raises method not defined if accessing via code only eg :hgb" do
            hash = described_class.load(HGB: hgb)

            expect { hash.xyz }.to raise_error(NoMethodError)
          end

          it "does not raise an error when accessed via using a suffix like _result" do
            hash = described_class.load(HGB: hgb)
            expect { hash.xyz_result }.not_to raise_error
          end
        end

        context "when the hash is a string" do
          it "works as expected" do
            allow(AllObservationCodes.instance).to receive(:all).once.and_return([:HGB])

            hash = described_class.load({ HGB: hgb }.to_json)

            expect(hash.hgb).to eq(hgb)
            expect(AllObservationCodes.instance).to have_received(:all)
          end
        end

        context "when hash has no HGB" do
          it "returns nil for hgb_* methods" do
            hash = described_class.load({})

            expect(hash.hgb_observed_at).to be_nil
            expect(hash.hgb_result).to be_nil
          end
        end
      end
    end
  end
end
