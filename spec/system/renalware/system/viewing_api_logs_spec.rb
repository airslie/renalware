module Renalware
  describe "Viewing API logs" do
    let(:user) { create(:user) }

    it "displays a paginated list of API Log events" do
      login_as_super_admin

      create(:api_log, :working, identifier: "ABC", records_added: 8888888)
      create(:api_log, :done, identifier: "XYZ", records_updated: 2222222, error: "big error")

      visit system_api_logs_path

      expect(page).to have_text "API Logs"
      expect(page).to have_text "ABC"
      expect(page).to have_text "XYZ"
      expect(page).to have_text "working"
      expect(page).to have_text "8888888"
      expect(page).to have_text "2222222"
      expect(page).to have_text "big error"
    end
  end
end
