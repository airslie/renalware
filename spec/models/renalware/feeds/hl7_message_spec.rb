module Renalware::Feeds
  describe HL7Message do
    # We are sort of testing the MessageParser here also which is not ideal, but its role in parsing
    # the message to make it loadable into an HL7Messages is key.
    subject(:decorator) { MessageParser.parse(raw_message) }

    let(:message_type) { "ORU^R01" }
    let(:sex) { "F" }
    let(:raw_message) do
      msg = <<~RAW
        MSH|^~\&|HM|LBE|SCM||20091112164645||#{message_type}|1258271|P|2.3.1|||AL||||
        PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|#{sex}|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
        PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
        ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
        OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
        OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
      RAW
      msg
    end

    describe "#patient_dob" do
      it "extracts the PID.5 Date of birth" do
        expect(decorator.patient_dob).to eq(Date.parse("19880924"))
      end
    end

    describe "#orc_filler_order_number" do
      context "when an ORC segment exists in the HL7 message" do
        it "extracts the ORC.3 Filler Order Number" do
          expect(decorator.orc_filler_order_number).to eq("09B0099478^LA")
        end
      end

      context "when an ORC segment does not exist in the HL7 message" do
        let(:raw_message) do
          <<~RAW
            MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20191030155640||MFN^M02|1861609776|P|2.3|||AL|AL
            MFI|STF|PIMS|UPD|20191030155640|20191030155640|NE
            MFE|MAD|1861609776|20191030155640|193814
            STF|193814|C1119528^^^^MAINCODE~XXX^^^^DG~C1119528^^^^GMC|Xxx^Xxxx^^^Mr|CONLT|UNKNOWN||A|100^Trauma and Orthopaedic~102^Fracture||020 0000 000^PHONE|X Hospital NHS Foundation Trust^Somewhere^London, Greater London^^N1 1AAS^UK^BUSIN|20120912000000
            PRA|200000|XYZ^XX Hospital NHS Trust^TRUST|||100^NAT^MAIN~TRAUMA^DG^MAIN~01^ABC^MAIN~FRAC^DG^SEC1~020^LOCAL^SEC1|||20120912
          RAW
        end

        it "returns nil" do
          expect(decorator.orc_filler_order_number).to be_nil
        end
      end
    end

    describe "#orc_order_status" do
      context "when an ORC segment exists in the HL7 message" do
        it "extracts the ORC .5 Order Status" do
          expect(decorator.orc_order_status).to eq("CM")
        end
      end

      context "when an ORC segment does not exist in the HL7 message" do
        let(:raw_message) do
          <<~RAW
            MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20191030155640||MFN^M02|1861609776|P|2.3|||AL|AL
            MFI|STF|PIMS|UPD|20191030155640|20191030155640|NE
            MFE|MAD|1861609776|20191030155640|193814
            STF|193814|C1119528^^^^MAINCODE~XXX^^^^DG~C1119528^^^^GMC|Xxx^Xxxx^^^Mr|CONLT|UNKNOWN||A|100^Trauma and Orthopaedic~102^Fracture||020 0000 000^PHONE|X Hospital NHS Foundation Trust^Somewhere^London, Greater London^^N1 1AAS^UK^BUSIN|20120912000000
            PRA|200000|XYZ^XX Hospital NHS Trust^TRUST|||100^NAT^MAIN~TRAUMA^DG^MAIN~01^ABC^MAIN~FRAC^DG^SEC1~020^LOCAL^SEC1|||20120912
          RAW
        end

        it "returns nil" do
          expect(decorator.orc_order_status).to be_nil
        end
      end
    end

    describe "#message_type" do
      subject { decorator.message_type }

      context "when message type and event type are present and delimited correctly" do
        let(:message_type) { "ORU^R01" }

        it { is_expected.to eq("ORU") }
      end

      context "when only message type is present" do
        let(:message_type) { "ORU" }

        it { is_expected.to eq("ORU") }
      end

      context "when message type and event type are blank" do
        let(:message_type) { "" }

        it { is_expected.to be_blank }
      end
    end

    describe "#event_type" do
      subject { decorator.event_type }

      context "when message type and event type are present and delimited correctly" do
        let(:message_type) { "ORU^R01" }

        it { is_expected.to eq("R01") }
      end

      context "when only event type is present" do
        let(:message_type) { "^R01" }

        it { is_expected.to eq("R01") }
      end

      context "when message type and event type are blank" do
        let(:message_type) { "" }

        it { is_expected.to be_blank }
      end
    end

    describe "#type" do
      subject { decorator.type }

      it { is_expected.to eq("ORU^R01") }
    end

    describe "#oru?" do
      subject { decorator.oru? }

      context "when a pathology ORU message" do
        let(:message_type) { "ORU^R01" }

        it { is_expected.to be(true) }
      end

      context "when an ADT message" do
        let(:message_type) { "ADT^A31" }

        it { is_expected.to be_falsey }
      end
    end

    describe "#adt?" do
      subject { decorator.adt? }

      context "when a pathology ORU message" do
        let(:message_type) { "ORU^R01" }

        it { is_expected.to be_falsey }
      end

      context "when an ADT message" do
        let(:message_type) { "ADT^A31" }

        it { is_expected.to be(true) }
      end
    end

    describe "#action" do
      subject { decorator.action }

      context "when a pathology ORU message" do
        let(:message_type) { "ORU^R01" }

        it { is_expected.to eq(:add_pathology_observations) }
      end

      context "when there is an unhandled message" do
        let(:message_type) { "ADT^Z99" }

        it { is_expected.to eq(:no_matching_command) }
      end

      context "when an ADT^A31 message" do
        let(:message_type) { "ADT^A31" }

        it { is_expected.to eq(:update_person_information) }
      end
    end

    context "when the message type is MFN^M02" do
      let(:raw_message) do
        <<~RAW
          MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20191030155640||MFN^M02|1861609776|P|2.3|||AL|AL
          MFI|STF|PIMS|UPD|20191030155640|20191030155640|NE
          MFE|MAD|1861609776|20191030155640|193814
          STF|193814|C1119528^^^^MAINCODE~XXX^^^^DG~C1119528^^^^GMC|Xxx^Xxxx^^^Mr|CONLT|UNKNOWN||A|100^Trauma and Orthopaedic~102^Fracture||020 0000 000^PHONE|X Hospital NHS Foundation Trust^Somewhere^London, Greater London^^N1 1AAS^UK^BUSIN|20120912000000
          PRA|200000|XYZ^XX Hospital NHS Trust^TRUST|||100^NAT^MAIN~TRAUMA^DG^MAIN~01^ABC^MAIN~FRAC^DG^SEC1~020^LOCAL^SEC1|||20120912
        RAW
      end

      describe "#message_type" do
        subject { decorator.message_type }

        it { is_expected.to eq("MFN") }
      end

      describe "patient_identification" do
        subject(:pi) { decorator.patient_identification }

        it "returns a blank internal_id because none is available" do
          expect(pi.internal_id).to be_nil
        end
      end
    end

    describe HL7Message::Observation do
      let(:raw_message) do
        <<~RAW
          MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
          PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|#{sex}|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
          OBR|2|BRM-21B846500|BRM-0021B846500|FBC^FULL BLOOD COUNT^WinPath||202111111228|202111111221||||||copd excetrbation ? sob||B^Blood|EMD^A\T\E Consultant||||||202111111240||BLS|F
          OBX|2|NM|WBC^White Blood Cell Count^WinPath||12.8\\.br\\This result could indicate your patient might have\\.br\\sepsis.|x 10^9/l|4 - 10|H|||F
          OBX|8|NM|ALT^A.L.T^WinPath||54¬ALT <80 IU/L is rarely significant and is often¬related to a raised BMI.|IU/L|0 - 50|H|||F
        RAW
      end

      describe "comment" do
        it "strips anything after .br as the comment - unfort the escaping may mean lost chars " \
           "e.g. epsis => epsis - I can't think of a safe way around this atm" do
          obs = decorator.observation_requests.first.observations.first
          expect(obs).to have_attributes(
            value: "12.8",
            comment: "This result could indicate your patient might have sepsis."
          )
        end

        it "strips anything after .br as the comment - unfort the escaping may mean lost chars " \
           "e.g. epsis => epsis - I can't think of a safe way around this atm" do
          obs = decorator.observation_requests.first.observations.last
          expect(obs).to have_attributes(
            value: "54",
            comment: "ALT <80 IU/L is rarely significant and is often related to a raised BMI."
          )
        end
      end
    end

    describe HL7Message::ObservationRequest do
      describe "observed_at" do
        context "when OBR.7 is present" do
          let(:raw_message) do
            <<~RAW
              MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
              PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|#{sex}|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
              OBR|2|BRM-21B846500|BRM-0021B846500|FBC^FULL BLOOD COUNT^WinPath||202111110000|202222221111||||||||B^Blood|EMD^A\T\E Consultant||||||202111111240||BLS|F
            RAW
          end

          it "returns OBR.7" do
            obr = decorator.observation_requests.first
            expect(obr.observed_at).to eq("202222221111")
          end
        end

        context "when OBR.7 is missing" do
          let(:raw_message) do
            <<~RAW
              MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
              PID||123456789^^^NHS|Z999990^^^HOSP1||RABBIT^JESSICA^^^MS||19880924|#{sex}|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
              OBR|2|BRM-21B846500|BRM-0021B846500|FBC^FULL BLOOD COUNT^WinPath||202111110000|||||||||B^Blood|EMD^A\T\E Consultant||||||202111111240||BLS|F
            RAW
          end

          it "returns OBR.6" do
            obr = decorator.observation_requests.first
            expect(obr.observed_at).to eq("202111110000")
          end
        end
      end
    end
  end
end
