# frozen_string_literal: true

module Renalware
  describe "pd regime bag's days assigned are by default set all to true" do
    it "days can be deleselected when creating a new pd regime", js: true do
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
        expect(page).to have_content("Sun, Mon, Wed, Fri, Sat")
      end
    end
  end
end
