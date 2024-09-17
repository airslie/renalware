# frozen_string_literal: true

module Renalware::Feeds::HL7Segments
  describe PV2 do
    subject(:pv2) { Renalware::Feeds::MessageParser.parse(raw_message).pv2 }

    let(:raw_message) { "PV2||||||||20210809130000|||||||||||||||||||||||||||||||||||||||" }

    it "#expected_admit_date" do
      expect(pv2.expected_admit_date).to eq(Time.zone.parse("20210809130000"))
    end
  end
end
