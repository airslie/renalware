# frozen_string_literal: true

describe "View transmission logs" do
  describe "GET index" do
    it "displays a paginated list of transmission logs, most recent first" do
      login_as_super_admin
      create(:ukrdc_transmission_log, sent_at: "2021-01-01 11:00", status: :sftped)

      visit ukrdc_transmission_logs_path

      expect(page).to have_content("UKRDC Transmission Logs")

      within ".ukrdc_transmission_logs" do
        expect(page).to have_content("01-Jan-2021 11:00")
        expect(page).to have_content("sftped")
      end
    end
  end
end
