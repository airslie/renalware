module Renalware::Feeds::HL7Segments
  describe MRG do
    subject(:mrg) { Renalware::Feeds::MessageParser.parse(raw_message).mrg.first }

    before do
      allow(Renalware.config).to receive_messages(
        patient_hospital_identifiers: {
          HOSP_A: :local_patient_id,
          HOSP_B: :local_patient_id_2,
          HOSP_C: :local_patient_id_3
        }
      )
    end

    describe "#prior_identifiers" do
      context "when there are prior patient identifiers" do
        let(:raw_message) { "MRG|123^^^HOSP_A~456^^^HOSP_B^MRN^~789^^^HOSP_C" }

        it "returns a hash of assigning authority to hospital number" do
          expect(mrg.prior_identifiers).to eq(
            local_patient_id: "123",
            local_patient_id_2: "456",
            local_patient_id_3: "789"
          )
        end
      end

      context "when there are no prior patient identifiers" do
        let(:raw_message) { "MRG|" }

        it "returns an empty array" do
          expect(mrg.prior_identifiers).to eq([])
        end
      end
    end
  end
end
