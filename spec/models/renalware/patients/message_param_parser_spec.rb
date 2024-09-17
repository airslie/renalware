# frozen_string_literal: true

module Renalware::Patients
  describe MessageParamParser do
    describe "#parse" do
      let(:hl7_message) {
        instance_double(
          Renalware::Feeds::HL7Message,
          patient_identification: double(
            internal_id: "::internal id::",
            external_id: "::external id::",
            family_name: "::family name::",
            given_name: "::given name::",
            sex: "F",
            dob: "19880924"
          )
        )
      }

      it "transfers attributes from the message payload to the params" do
        params = described_class.new.parse(hl7_message)

        expect(params).to eq(
          patient: {
            nhs_number: "::external id::",
            local_patient_id: "::internal id::",
            family_name: "::family name::",
            given_name: "::given name::",
            sex: "F",
            born_on: "1988-09-24"
          }
        )
      end
    end
  end
end
