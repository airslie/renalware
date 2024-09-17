# frozen_string_literal: true

describe "HD Summary (Dashboard)" do
  describe "GET" do
    it "renders the patient's HD Summary" do
      patient = create(:hd_patient)

      get patient_hd_dashboard_path(patient)

      expect(response).to be_successful
    end
  end
end
