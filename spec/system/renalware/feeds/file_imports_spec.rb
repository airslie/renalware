describe "File Import viewing and uploading" do
  describe "Listing file imports" do
    it "responds successfully with a paginated list of file imports" do
      user = create(:user)
      create(:feed_file, by: user)

      login_as_clinical
      visit admin_feeds_files_path

      expect(page).to have_text(user.family_name)
      expect(page).to have_text("Primarycarephysicians")
    end
  end
end
