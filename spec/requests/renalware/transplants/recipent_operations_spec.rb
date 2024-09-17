# frozen_string_literal: true

describe "Transplant Recipient Operation" do
  let(:patient) { create(:transplant_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  describe "GET show" do
    it "responds successfully" do
      operation = create(:transplant_recipient_operation, patient: patient)

      get patient_transplants_recipient_operation_path(patient, operation)

      expect(response).to be_successful
    end
  end
end
