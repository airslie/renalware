# frozen_string_literal: true

describe "Renal Registry Preflight checks" do
  describe "GET patients" do
    it "renders a list of patients with incomplete data" do
      # This fails intermitantly - esp when other tests have run beforehand

      login_as_clinical
      visit patients_renal_registry_preflight_checks_path

      expect(page).to have_content("Renal Registry")
    end
  end

  describe "GET death" do
    it "renders a list of deceased patients with incomplete data" do
      login_as_clinical
      visit deaths_renal_registry_preflight_checks_path

      expect(page).to have_content("Renal Registry")
    end
  end

  describe "GET missing_esrf" do
    it "renders a list of patients with missing esrf date" do
      # This fails intermitantly - esp when other tests have run beforehand

      login_as_clinical
      visit missing_esrf_renal_registry_preflight_checks_path

      expect(page).to have_content("Renal Registry")
    end
  end
end
