module Renalware
  module UKRDC
    describe PathologyObservationPresenter do
      # Assumes the thing being passed to the ctor is of type ObservationPresenter hence
      # responds to description_code
      describe "#pre_post" do
        it "returns NA is the patient is no on HD" do
          observation = OpenStruct.new(description_code: "UREP")
          result = described_class.new(observation).pre_post(patient_is_on_hd: false)
          expect(result).to eq("NA")
        end

        context "when patient is on HD" do
          it "returns POST for UREP observation code" do
            %w(UREP urep).each do |code|
              observation = OpenStruct.new(description_code: code)
              result = described_class.new(observation).pre_post(patient_is_on_hd: true)
              expect(result).to eq("POST")
            end
          end

          it "returns PRE for other observation codes" do
            %w(URR RBC WBC urepp UREPP).each do |code|
              observation = OpenStruct.new(description_code: code)
              result = described_class.new(observation).pre_post(patient_is_on_hd: true)
              expect(result).to eq("PRE")
            end
          end
        end
      end

      describe "coding_standard" do
        context "when rr_coding_standard is :ukrr" do
          it "returns URRR" do
            observation = OpenStruct.new(description_rr_coding_standard: :ukrr)

            expect(described_class.new(observation).coding_standard).to eq("UKRR")
          end
        end

        context "when rr_coding_standard is :pv" do
          it "returns PV" do
            observation = OpenStruct.new(description_rr_coding_standard: :pv)

            expect(described_class.new(observation).coding_standard).to eq("PV")
          end
        end
      end

      describe "code" do
        context "when the obs has a loinc_code" do
          it "uses that" do
            observation = OpenStruct.new(
              description_loinc_code: "LOINC",
              description_code: "OTHER"
            )
            expect(described_class.new(observation).code).to eq("LOINC")
          end
        end

        context "when the obs has a '' loinc_code" do
          it "uses the normal code" do
            observation = OpenStruct.new(
              description_loinc_code: "",
              description_code: "OTHER"
            )
            expect(described_class.new(observation).code).to eq("OTHER")
          end
        end

        context "when the obs has a nil loinc_code" do
          it "uses the normal code" do
            observation = OpenStruct.new(
              description_loinc_code: nil,
              description_code: "OTHER"
            )
            expect(described_class.new(observation).code).to eq("OTHER")
          end
        end
      end

      describe "#interpretation_code" do
        it "maps possible lab values to UKRDC OBX:8 abbreviations" do
          {
            "Positive" => "POS",
            "positive" => "POS",
            " Negative " => "NEG",
            " bla " => "UNK",
            "indeterminate" => "UNK"

          }.each do |description, abbrev|
            observation = instance_double(Pathology::Observation, result: description)

            expect(described_class.new(observation).interpretation_code).to eq(abbrev)
          end
        end
      end
    end
  end
end
