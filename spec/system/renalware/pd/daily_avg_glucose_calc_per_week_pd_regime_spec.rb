# frozen_string_literal: true

module Renalware
  describe "Daily average glucose(ml) calculated from bags per type assigned during one week",
           js: true do
    include PatientsSpecHelper

    before do
      patient = create(:patient)
      set_modality(patient: patient,
                   modality_description: create(:pd_modality_description),
                   by: User.first)

      # bag_type_13_6
      create(:bag_type,
             manufacturer: "Baxter",
             description: "Dianeal PD2 1.36% (Yellow)",
             glucose_content: 1.3,
             glucose_strength: :low)

      # bag_type_22_7
      create(:bag_type,
             manufacturer: "Baxter",
             description: "Dianeal PD2 2.27% (Green)",
             glucose_content: 2.2,
             glucose_strength: :medium)

      # bag_type_38_6
      create(:bag_type,
             manufacturer: "Baxter",
             description: "Dianeal PD2 3.86% (Red)",
             glucose_content: 3.8,
             glucose_strength: :high)

      login_as_clinical

      visit patient_pd_dashboard_path(patient)
    end

    it "returns daily average volume (ml) for each concentration type" do
      within ".page-actions" do
        click_link "Add"
        click_link "CAPD Regime"
      end

      select "CAPD 3 exchanges per day", from: "Treatment"

      fill_in "Start date", with: "18/04/2015"

      # bag 1
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(1)") do
        select "Dianeal PD2 1.36% (Yellow)", from: "* Bag type"

        select "2000", from: "Volume (ml)"

        uncheck "Mon"
        uncheck "Wed"
        uncheck "Fri"
        uncheck "Sat"
      end

      # bag 2
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(2)") do
        select "Dianeal PD2 2.27% (Green)", from: "* Bag type"

        select "2000", from: "Volume (ml)"

        uncheck "Tue"
        uncheck "Thu"
      end

      # bag 3
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(3)") do
        select "Dianeal PD2 3.86% (Red)", from: "* Bag type"

        select "2500", from: "Volume (ml)"

        uncheck "Sun"
        uncheck "Wed"
        uncheck "Fri"
      end

      # bag 4
      find("a.add-bag").click

      within("#pd-regime-bags div.fields:nth-child(4)") do
        select "Dianeal PD2 3.86% (Red)", from: "* Bag type"

        select "2000", from: "Volume (ml)"

        uncheck "Mon"
        uncheck "Wed"
        uncheck "Fri"
        uncheck "Sat"
      end

      click_on t("btn.create")

      expect(page).to have_content("Low strength\n857 ml")
      expect(page).to have_content("Med. strength\n1428 ml")
      expect(page).to have_content("High strength\n2285 ml")
    end
  end
end
