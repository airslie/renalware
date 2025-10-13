module Renalware::Feeds
  describe PatientIdentification do # rubocop:disable RSpec/SpecFilePathFormat
    subject(:pi) { MessageParser.parse(raw_message).patient_identification }

    describe "patient numbers" do
      let(:raw_message) do
        <<~RAW
          PID||123456789^^^NHS^ignoreme|D7006359^^^PAS1~X1234^^^PAS2~^^^EMPTY|
        RAW
      end

      describe "#internal_id (the first hosp number)" do
        it { expect(pi.internal_id).to eq("D7006359") }
      end

      describe "#hospital_identifiers (allowing for > 1 hosp number)" do
        it do
          expect(pi.hospital_identifiers).to eq(
            {
              PAS1: "D7006359",
              PAS2: "X1234"
            }
          )
        end
      end

      describe "#nhs_number" do
        context "when NHS number is in PID-2" do
          let(:raw_message) do
            <<~RAW
              PID||123456789^^^NHS||
            RAW
          end

          it { expect(pi.nhs_number).to eq("123456789") }
        end

        context "when NHS number is in PID-3 with assigning authority NHSNBR (BLT style)" do
          let(:raw_message) do
            <<~RAW
              PID|||123456789^^^NHSNBR~MRN1^^^AUTH1~MRN2^^^AUTH2|
            RAW
          end

          it { expect(pi.nhs_number).to eq("123456789") }
        end
      end
    end

    describe "#title" do
      subject { pi.title }

      let(:raw_message) { "PID|||||RABBIT^JESSICA^^^  MS  |||||||||||||||||||||||||" }

      it { is_expected.to eq("MS") }
    end

    describe "#family_name" do
      subject { pi.family_name }

      let(:raw_message) { "PID||||| RABBIT ^JESSICA^^^MS|||||||||||||||||||||||||" }

      it { is_expected.to eq("RABBIT") }
    end

    describe "#given_name" do
      subject { pi.given_name }

      let(:raw_message) { "PID|||||RABBIT^  JESSICA  ^^^MS|||||||||||||||||||||||||" }

      it { is_expected.to eq("JESSICA") }
    end

    describe "#suffix" do
      subject { pi.suffix }

      let(:raw_message) { "PID|||||RABBIT^JESSICA^^  MBE ^MS|||||||||||||||||||||||||" }

      it { is_expected.to eq("MBE") }
    end

    describe "#address including HL& escaped characters eg \T\ = &" do
      subject { pi.address }

      let(:raw_message) do
        <<~'RAW'
          PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBIT \T\ HOLE ROAD^Gin \T\ Tonic^^^SE8 8JR|||||||||||||||||||
        RAW
      end

      it { is_expected.to eq(["18 RABBIT & HOLE ROAD", "Gin & Tonic", "", "", "SE8 8JR"]) }

      context "when address is nil" do
        let(:raw_message) do
          <<~RAW
            PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|F
          RAW
        end

        it { is_expected.to eq([]) }
      end
    end

    describe "#sex (mapping PID sex to Renalware sex)" do
      subject { pi.sex }

      let(:raw_message) do
        <<~RAW
          PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|#{sex}|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
        RAW
      end

      {
        "FEMALE" => "F",
        "female" => "F",
        "f" => "F",
        "MALE" => "M",
        "male" => "M",
        "m" => "M",
        "UNKNOWN" => "NK",
        "unknown" => "NK",
        "NOTKNOWN" => "NK",
        "OTHER" => "NS",
        "other" => "NS",
        "Ambiguous" => "NS",
        "Not applicable" => "NS",
        "XyXy" => "XYXY",
        "BOTH" => "NS",
        "" => ""

      }.each do |original, mapped|
        context "when PID sex is #{original}" do
          let(:sex) { original }

          it { is_expected.to eq(mapped) }
        end

        context "when PID sex is #{original} and has a desription in the message" do
          let(:raw_message) do
            <<~RAW
              PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|#{sex}^SEXDESC|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
            RAW
          end

          let(:sex) { original }

          it { is_expected.to eq(mapped) }
        end
      end
    end

    describe "telephone numbers and email" do
      context "when phone_home PID.13 is nil" do
        let(:raw_message) do
          <<~RAW
            PID|||||||
          RAW
        end

        it do
          expect(pi.email).to be_nil
          expect(pi.telephone).to eq([])
        end
      end

      context "when phone_home PID.13 present" do
        let(:raw_message) do
          <<~RAW
            PID|||||||||||||tel1^MOBILE~tel2^HOME~testrenal@test.co^EMAIL|
          RAW
        end

        it do
          expect(pi.telephone).to eq(["MOBILE: tel1", "HOME: tel2"])
          expect(pi.email).to eq("testrenal@test.co")
        end
      end

      context "when phone_home PID.13 present with a different order" do
        let(:raw_message) do
          <<~RAW
            PID|||||||||||||tel1^MOBILE~testrenal@test.co^EMAIL~tel2^HOME|
          RAW
        end

        it do
          expect(pi.telephone).to eq(["MOBILE: tel1", "HOME: tel2"])
          expect(pi.email).to eq("testrenal@test.co")
        end
      end

      context "when phone_home PID.13 present with no types" do
        let(:raw_message) do
          <<~RAW
            PID|||||||||||||tel1~tel2~testrenal@test.co^EMAIL|
          RAW
        end

        it do
          expect(pi.telephone).to eq(%w(tel1 tel2))
          expect(pi.email).to eq("testrenal@test.co")
        end
      end
    end

    describe "marital_status" do
      {
        S: :single,
        M: :married,
        D: :divorced,
        W: :widowed,
        X: nil,
        UNKNOWN: nil
      }.each do |key, value|
        it "maps #{key} to #{value || 'nil'}" do
          raw_message = "PID||||||||||||||||#{key}|"
          pi = MessageParser.parse(raw_message).patient_identification

          expect(pi.marital_status).to eq(value)
        end
      end
    end
  end
end
