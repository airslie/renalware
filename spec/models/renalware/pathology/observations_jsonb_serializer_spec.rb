module Renalware
  module Pathology
    describe ObservationsJsonbSerializer do
      let(:hgb) { { "result" => "23.1", "observed_at" => "2017-12-12 01:01:01" } }

      it "splits only recognised trailing suffixes from observation codes" do
        hash = described_class.load({})

        {
          P_URE: [:P_URE, ""],
          p_ure: [:P_URE, ""],
          P_URE_result: [:P_URE, "_result"],
          p_ure_result: [:P_URE, "_result"],
          P_URE_observed_at: [:P_URE, "_observed_at"],
          p_ure_observed_at: [:P_URE, "_observed_at"],
          URE: [:URE, ""],
          ure: [:URE, ""],
          URE_result: [:URE, "_result"],
          ure_result: [:URE, "_result"],
          URE_observed_at: [:URE, "_observed_at"],
          ure_observed_at: [:URE, "_observed_at"],
          P_URE_unknown: [:P_URE_UNKNOWN, ""],
          P_URE_result_extra: [:P_URE_RESULT_EXTRA, ""]
        }.each do |method_name, expected|
          expect(hash.method_parts(method_name)).to eq(expected)
        end
      end

      it "retrieves observations with underscores in their codes" do
        ObservationDescription.create!(code: "P_URE")
        hash = described_class.load(P_URE: hgb)

        expect(hash.P_URE).to eq(hgb)
        expect(hash.p_ure).to eq(hgb)
        expect(hash.P_URE_result).to eq(hgb["result"])
        expect(hash.p_ure_result).to eq(hgb["result"])
        expect(hash.P_URE_observed_at).to eq(Date.new(2017, 12, 12))
        expect(hash.p_ure_observed_at).to eq(Date.new(2017, 12, 12))
      end

      it "preserves retrieval of existing codes without underscores" do
        ObservationDescription.create!(code: "URE")
        hash = described_class.load(URE: hgb)

        expect(hash.URE).to eq(hgb)
        expect(hash.ure).to eq(hgb)
        expect(hash.URE_result).to eq(hgb["result"])
        expect(hash.ure_result).to eq(hgb["result"])
        expect(hash.URE_observed_at).to eq(Date.new(2017, 12, 12))
        expect(hash.ure_observed_at).to eq(Date.new(2017, 12, 12))
      end

      describe "dynamic OBX methods via method missing" do
        it "allows retrieval of the observation hash via a method with the name of the OBX code" do
          ObservationDescription.create!(code: "HGB")

          hash = described_class.load(HGB: hgb)

          expect(hash.hgb).to eq(hgb)
          expect(hash.HGB).to eq(hgb)
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
            ObservationDescription.create!(code: "HGB")

            hash = described_class.load({ HGB: hgb }.to_json)

            expect(hash.hgb).to eq(hgb)
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
