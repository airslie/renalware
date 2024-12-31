module Renalware
  describe Pathology::ObservationRequest do
    include PathologySpecHelper

    it :aggregate_failures do
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:requested_at)
      is_expected.to validate_presence_of(:requestor_name)
      is_expected.to belong_to(:patient).touch(true)
    end

    describe "distinct_for_patient_id" do
      it "returns the most recently processed OBR for a given " \
         "requestor_order_number + requested_at + description_id" do
        patient = create(:pathology_patient)
        requested_at = "2019-01-01"
        updated_request = create_request_with_observations(
          requested_at: requested_at,
          requestor_order_number: "X1",
          obr_code: "OBR1",
          obx_codes: %w(OBX1 OBX2),
          patient: patient,
          created_at: 1.day.ago
        )
        _original_request = create_request_with_observations(
          requested_at: requested_at,
          requestor_order_number: "X1",
          obr_code: "OBR1",
          obx_codes: ["OBX1"],
          patient: patient,
          created_at: 2.days.ago
        )

        results = described_class.distinct_for_patient_id(patient.id)

        expect(results).to eq [updated_request]
        expect(
          results.first.observations
            .map { |x| x.description.code }
            .sort
        ).to eq %w(OBX1 OBX2)
      end
    end
  end
end
