describe "Searching people" do
  describe "GET index" do
    before do
      by = login_as_clinical
      create(:directory_person, given_name: "Yosemite", family_name: "Sam", by:)
      create(:directory_person, family_name: "::another patient::", by:)

      visit directory.people_path
    end

    context "with a name filter" do
      it "responds with a filtered list of people" do
        fill_in "Name contains", with: "sam"
        click_on t("btn.filter")

        within("table.people") do
          expect(page).to have_text("Yosemite")
        end
      end
    end
  end
end
