describe "Viewing patients merges" do
  describe "GET index" do
    it "returns a successful response" do
      user = create(:user)
      minor_patient = create(:patient, :minimal, family_name: "Minor", by: user)
      major_patient = create(:patient, :minimal, family_name: "Major", by: user)

      create(
        :patient_merge,
        major_patient:,
        minor_patient:
      )

      get patients_merges_path

      expect(response).to be_successful
      expect(response.body).to include("Patient Merges")
      expect(response.body).to include("Major")
      expect(response.body).to include("Minor")
    end
  end
end
