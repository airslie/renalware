module Renalware
  describe "Live Donors", js: false do
    include PatientsSpecHelper

    def create_live_donor(by:)
      live_donor = create(:patient, family_name: "Quark")
      set_modality(patient: live_donor,
                   modality_description: create(:live_donor_modality_description),
                   by: by)
      live_donor
    end

    def create_non_live_donor
      create(:patient, family_name: "Smith")
    end

    it "Viewing the list of live donors" do
      login_as_clinical
      user = User.first # the clinician we just implicitly created
      live_donor = create_live_donor(by: user)
      non_live_donor = create_non_live_donor

      visit root_path
      within ".top-bar" do
        click_on "Renal"
        click_on "Live Donors"
      end

      expect(page).to have_current_path(transplants_live_donors_path)
      expect(page).to have_content(live_donor.family_name.upcase)
      expect(page).to have_no_content(non_live_donor.family_name.upcase)
    end
  end
end
