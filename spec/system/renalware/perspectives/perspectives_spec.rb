describe "Perspectives" do
  let(:patient) { create(:patient) }

  describe "Viewing patient perspectives", :system do
    it "Bone" do
      login_as_clinical

      visit patient_bone_perspective_path(patient)

      expect(page).to have_text("Bone")
      expect(page).to have_text("Prescriptions")
      # TODO: check graphs are rendering?
    end

    it "Anaemia" do
      login_as_clinical

      visit patient_anaemia_perspective_path(patient)

      expect(page).to have_text("Anaemia")
      expect(page).to have_text("Prescriptions")
      expect(page).to have_text("Iron Clinic Events")
      # TODO: check graphs are rendering?
    end
  end
end
