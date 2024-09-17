# frozen_string_literal: true

describe "Perspectives" do
  let(:patient) { create(:patient) }

  describe "Viewing patient perspectives", system: true do
    it "Bone" do
      login_as_clinical

      visit patient_bone_perspective_path(patient)

      expect(page).to have_content("Bone")
      expect(page).to have_content("Prescriptions")
      # TODO: check graphs are rendering?
    end

    it "Anaemia" do
      login_as_clinical

      visit patient_anaemia_perspective_path(patient)

      expect(page).to have_content("Anaemia")
      expect(page).to have_content("Prescriptions")
      expect(page).to have_content("Iron Clinic Events")
      # TODO: check graphs are rendering?
    end
  end
end
