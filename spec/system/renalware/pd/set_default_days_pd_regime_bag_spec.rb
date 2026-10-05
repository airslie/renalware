module Renalware
  describe "pd regime bag's days assigned are by default set all to true" do
    it "deselects all days only for the chosen dynamically added bag", :js do
      create(:bag_type, manufacturer: "CompanyA", description: "BagDescription")
      patient = create(:patient)
      login_as_clinical

      visit new_patient_pd_regime_path(patient, type: "PD::CAPDRegime")
      fill_in "Start date", with: "25/05/2015"
      select "CAPD 3 exchanges per day", from: "Treatment"
      click_link "Add Bag"
      click_link "Add Bag"
      expect(page).to have_css("#pd-regime-bags .fields", count: 2)

      within("#pd-regime-bags .fields:first-child") do
        select "CompanyA BagDescription", from: "* Bag type"
        select "2500", from: "Volume (ml)"
        expect(page).to have_css('.bag-days input[type="checkbox"]:checked', count: 7)
        click_link "Deselect all"
        expect(page).to have_no_css('.bag-days input[type="checkbox"]:checked')
        check "Mon"
      end

      within("#pd-regime-bags .fields:last-child") do
        select "CompanyA BagDescription", from: "* Bag type"
        select "2000", from: "Volume (ml)"
        expect(page).to have_css('.bag-days input[type="checkbox"]:checked', count: 7)
      end

      click_button "Create"
      expect(page).to have_current_path(patient_pd_dashboard_path(patient))
      bags = PD::Regime.find_by!(patient:).bags
      expect(bags.find_by!(volume: 2500).days).to eq(
        [false, true, false, false, false, false, false]
      )
      expect(bags.find_by!(volume: 2000).days).to eq([true, true, true, true, true, true, true])
    end

    it "days can be deleselected when creating a new pd regime", :js do
      create(:bag_type, manufacturer: "CompanyA", description: "BagDescription")
      patient = create(:patient)
      login_as_clinical

      visit new_patient_pd_regime_path(patient, type: "PD::CAPDRegime")
      fill_in "Start date", with: "25/05/2015"
      select "CAPD 3 exchanges per day", from: "Treatment"
      find("a.add-bag").click
      select "CompanyA BagDescription", from: "* Bag type"
      select "2500", from: "Volume (ml)"
      uncheck "Tue"
      uncheck "Thu"
      within ".patient-content" do
        click_on t("btn.create")
      end

      within ".current-regime" do
        expect(page).to have_text("Sun, Mon, Wed, Fri, Sat")
      end
    end
  end
end
