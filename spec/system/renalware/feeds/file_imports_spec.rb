describe "File Import viewing and uploading" do
  describe "Listing file imports" do
    it "responds successfully with a paginated list of file imports" do
      user = create(:user)
      type = create(:feed_file_type, name: "PrimaryCarePhysicians")
      create(
        :feed_file,
        file_type: type,
        created_by: user,
        updated_by: user,
        location: file_fixture("primary_care_physicians/egpcur.zip")
      )

      login_as_clinical
      visit admin_feeds_files_path

      expect(page).to have_content(user.family_name)
      expect(page).to have_content("Primarycarephysicians")
    end
  end
end
