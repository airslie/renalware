# frozen_string_literal: true

describe "Displaying the survey dashboard" do
  describe "GET show" do
    it "responds with the dashboard" do
      patient = create(:patient)
      get patient_surveys_dashboard_path(patient)

      expect(response).to be_successful
    end
  end
end
