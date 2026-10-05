module Renalware
  describe "AKI alert date shortcuts", :js do
    it "sets and clears the date in both the filter and calendar" do
      login_as_clinical
      visit renal_aki_alerts_path
      select "Specific date", from: "Date range"

      within "#specific-date" do
        fill_in "Date", with: "01-Jan-2001"
        click_link "Today"
        expect(page).to have_field("Date", with: Time.zone.today.strftime("%d-%b-%Y"))
        find_field("Date").click
      end
      expect(page).to have_css(
        ".flatpickr-calendar.open .flatpickr-day.selected.today",
        text: Time.zone.today.day.to_s,
        exact_text: true
      )

      click_button "Filter"
      expect(page).to have_field("Date", with: Time.zone.today.strftime("%d-%b-%Y"))

      within "#specific-date" do
        click_link "Clear"
        expect(page).to have_field("Date", with: "")
        find_field("Date").click
      end
      expect(page).to have_css(".flatpickr-calendar.open")
      expect(page).to have_no_css(".flatpickr-calendar.open .flatpickr-day.selected")

      click_button "Filter"
      expect(page).to have_field("Date", with: "")
    end
  end
end
