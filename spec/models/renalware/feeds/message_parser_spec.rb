# frozen_string_literal: true

module Renalware::Feeds
  describe MessageParser do
    subject(:message) { message_parser.parse(raw_message) }

    let(:message_parser) { described_class.new }

    describe "#parse" do
      context "with a message with >1 OBR each with >1 OBX observation segments" do
        let(:raw_message) do
          # Notes:
          # - In OBX:2, TX = Text data
          # - the \\S\\ is a result of a) Mirth encoding e.g. 10^12 as 10/S/12 and then b) our PG
          #   trigger replacing \S\ with \\S\\ when the delayed job row is inserted so that the
          #   string \S\12 is not interpreted by Ruby as a \n (!). Hence we expect \\S\\ to be
          #   mapped to ^ somewhere here in the code so that for example WBC units is converted
          #   to "10^12/L".
          <<~RAW
            MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
            PID|||Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
            PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
            ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
            OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
            OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
            OBX|2|TX|RBC^RBC^MB||4.00|10\\S\\9/L|||||F|||200911112026||BBKA^Donald DUCK|
            OBR|2|111111111^PCS|100000000^LA|RLU^RENAL/LIVER/UREA^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||100000000||||201801251249||HM|F
            OBX|1|NM|NA^Sodium^HM||136|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
            OBX|2|NM|POT^Potassium^HM||4.7|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
            OBX|3|NM|URE^Urea^HM||6.6|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
            NTE|1|L|This should be ignored
            OBX|4|NM|CRE^Creatinine^HM||102|umol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
          RAW
        end

        it :aggregate_failures do
          is_expected.to be_a(HL7Message)
          is_expected.to have_attributes(type: "ORU^R01", header_id: "1258271")
        end

        describe "#patient_identification" do
          subject { message.patient_identification }

          it do
            is_expected.to have_attributes(
              internal_id: "Z999990",
              external_id: "",
              family_name: "RABBIT",
              given_name: "JESSICA",
              sex: "F",
              dob: "19880924"
            )
          end
        end

        it "parses out multiple OBRs with their OBXs and ignores NTE elements" do
          message = message_parser.parse(raw_message)

          requests = message.observation_requests
          expect(requests).to be_a(Array)
          expect(requests.count).to eq(2)
          expect(requests.first.observations.count).to eq(2)
          expect(requests.last.observations.count).to eq(4)
        end

        it "assigns the observation request attributes to the message", :aggregate_failures do
          message = message_parser.parse(raw_message)

          request = message.observation_requests.first

          expect(request.identifier).to eq("FBC")
          expect(request.ordering_provider_name).to eq("KINGS MIDWIVES")
          expect(request.placer_order_number).to eq("123456")
          expect(request.observed_at).to eq("200911111841")
        end

        it "assigns the observation attributes" do
          message = message_parser.parse(raw_message)

          request = message.observation_requests.first
          obs = request.observations.first
          expect(obs.identifier).to eq("WBC")
          expect(obs.comment).to eq("")
          expect(obs.observed_at).to eq("200911112026")
          expect(obs.value).to eq("6.09")
          expect(obs.units).to eq("10^12/L")
        end

        it "assigns the payload to the message" do
          pending "Fails after to_s prepended with a to_s that joins using \\r"
          raw_message_without_trailing_cr = raw_message.strip
          message = message_parser.parse(raw_message_without_trailing_cr)

          expect(message.to_s).to eq(raw_message_without_trailing_cr)
        end
      end

      context "with a message with a single observation segment" do
        let(:raw_message) do
          <<~RAW
            MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
            PID|||Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
            PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
            ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
            OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
            OBX|1|TX|WBC^WBC^MB||6.09||||||F|||200911112026||BBKA^Donald DUCK|
          RAW
        end

        it "returns observations as a collection" do
          message = message_parser.parse(raw_message)

          expect(message.observation_requests.first.observations).to be_a(Array)
        end
      end

      context "with a message with a 'Cancelled' message in an OBX segment" do
        let(:raw_message) do
          <<~RAW
            MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
            PID|||Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
            PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
            ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
            OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
            OBX|1|TX|WBC^WBC^MB||##TEST CANCELLED## Insufficient specimen received||||||F|||200911112026||BBKA^Kenneth AMENYAH|
          RAW
        end

        it "replaces the cancelled text with something more concise" do
          obx = message.observation_requests.first.observations.first

          expect(obx.value).to eq("")
          expect(obx.cancelled).to be(true)
          expect(obx.comment).to eq("##TEST CANCELLED## Insufficient specimen received")
        end
      end
    end
  end
end
