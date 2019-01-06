# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe "pd regime bag's days assigned are by default set all to true", type: :system do
    before do
      @patient = create(:patient)
      @pd_regime_bag_1 = PD::RegimeBag.new
      @pd_regime_bag_2 = build(:pd_regime_bag,
                          sunday: true,
                          monday: false,
                          tuesday: true,
                          wednesday: false,
                          thursday: false,
                          friday: true,
                          saturday: false
                        )
      login_as_clinical
    end

    it "when creating a new pd regime bag, all days of week set by default as true" do
      expect(@pd_regime_bag_1.monday).to eq(true)
      expect(@pd_regime_bag_1.tuesday).to eq(true)
      expect(@pd_regime_bag_1.wednesday).to eq(true)
      expect(@pd_regime_bag_1.thursday).to eq(true)
      expect(@pd_regime_bag_1.friday).to eq(true)
      expect(@pd_regime_bag_1.saturday).to eq(true)
      expect(@pd_regime_bag_1.sunday).to eq(true)
    end

    it "when creating a new pd regime bag, some days are deselected", js: true do
      visit new_patient_pd_regime_path(@patient, type: "PD::CAPDRegime")

      fill_in "Start date", with: "25/05/2015"

      select "CAPD 3 exchanges per day", from: "Treatment"

      find("a.add-bag").click

      select "Star Brand, Lucky Brand Green–2.34", from: "* Bag type"

      select "2500", from: "Volume (ml)"

      uncheck "Tue"

      uncheck "Thu"

      within ".patient-content" do
        click_on "Save"
      end

      within ".current-regime" do
        expect(page).to have_content("Sun, Mon, Wed, Fri, Sat")
      end
    end
  end
end
