# frozen_string_literal: true

module Renalware::Feeds::HL7Segments
  describe PV1 do
    subject(:pv1) { Renalware::Feeds::MessageParser.parse(raw_message).pv1 }

    let(:raw_message) do
      <<~RAW
        PV1||O|Clinic1^Name^Desc^RQ8|||||G123456^ROBINSON^BA^^^DR^^^^^^^NATGP|GMC123123^Smith^Francis^^^MR^^^^^^^SDSID|300|||||||||VisitNumber123|||||||||||||||||||||||||||||||||
      RAW
    end

    it "#referring_doctor" do
      expect(pv1.referring_doctor).to have_attributes(
        code: "G123456",
        family_name: "ROBINSON",
        given_name: "BA",
        title: "DR",
        type: "NATGP"
      )
    end

    it "#consulting_doctor" do
      expect(pv1.consulting_doctor).to have_attributes(
        code: "GMC123123",
        family_name: "Smith",
        given_name: "Francis",
        title: "MR",
        type: "SDSID",
        name: "MR Francis Smith"
      )
    end

    it "#clinic" do
      expect(pv1.clinic).to have_attributes(
        code: "Clinic1",
        name: "Name",
        description: "Desc"
      )
    end

    it "#visit_number" do
      expect(pv1.visit_number).to eq("VisitNumber123")
    end
  end
end
