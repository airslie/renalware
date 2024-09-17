# frozen_string_literal: true

describe "Changing a patient's GP (primary care physician)" do
  let(:patient) { create(:patient) }
  let(:primary_care_physician) { create(:primary_care_physician) }

  describe "GET edit" do
    it "responds with a form" do
      get edit_patient_primary_care_physician_path(patient)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { patient: { primary_care_physician_id: primary_care_physician.id } }

        patch patient_primary_care_physician_path(patient), params: attributes

        expect(response).to have_http_status(:redirect)

        follow_redirect!

        expect(response).to be_successful
        expect(patient.reload.primary_care_physician).to eq(primary_care_physician)
      end
    end
  end

  describe "DELETE destroy" do
    it "remove a record" do
      attributes = { patient: { primary_care_physician_id: primary_care_physician.id } }

      delete patient_primary_care_physician_path(patient, format: :js), params: attributes

      expect(response).to be_successful
      expect(patient.reload.primary_care_physician).to be_nil
    end
  end
end
