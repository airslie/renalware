# frozen_string_literal: true

module Renalware
  describe "Viewing API logs" do
    let(:user) { create(:user) }

    it "displays a paginated list of API Log events" do
      login_as_super_admin

      create(:api_log, :working, identifier: "ABC", records_added: 8888888)
      create(:api_log, :done, identifier: "XYZ", records_updated: 2222222, error: "big error")

      visit system_api_logs_path

      expect(page).to have_content "API Logs"
      expect(page).to have_content "ABC"
      expect(page).to have_content "XYZ"
      expect(page).to have_content "working"
      expect(page).to have_content "8888888"
      expect(page).to have_content "2222222"
      expect(page).to have_content "big error"
    end
  end
end
