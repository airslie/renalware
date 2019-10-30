# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe HL7Message do
    # We are sort of testing the MessageParser here also which is not ideal, but its role in parsing
    # the message to make it loadable into an HL7Messages is key.
    subject(:decorator) { MessageParser.parse(raw_message) }

    let(:message_type) { "ORU^R01" }
    let(:raw_message) do
      msg = <<-RAW.strip_heredoc
        MSH|^~\&|HM|LBE|SCM||20091112164645||#{message_type}|1258271|P|2.3.1|||AL||||
        PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
        PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
        ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
        OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
        OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
      RAW
      msg
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

        it { is_expected.to eq(true) }
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

        it { is_expected.to eq(true) }
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

    describe "#patient_identification" do
      subject(:pi) { decorator.patient_identification }

      describe "#address" do
        subject { pi.address }

        it { is_expected.to eq(["18 RABBITHOLE ROAD", "LONDON", "", "", "SE8 8JR"]) }
      end
    end
  end
end
