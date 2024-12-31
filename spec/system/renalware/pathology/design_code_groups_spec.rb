module Renalware::Pathology
  describe "Design pathology code groups" do
    describe "listing code groups" do
      it do
        group = create(:pathology_code_group, name: "Group1", description: "TheDesc", title: "ABC")
        login_as_super_admin

        visit pathology_code_groups_path

        expect(page).to have_content "Pathology Code Groups"

        within ".code-groups-table" do
          expect(page).to have_content group.name
          expect(page).to have_content group.title
          expect(page).to have_content group.description
          expect(page).to have_content "View"
        end
      end
    end

    describe "viewing a code group" do
      it do
        group = create(:pathology_code_group, name: "Group1", description: "TheDesc")

        login_as_super_admin

        visit pathology_code_group_path(group)

        expect(page).to have_content "Group1"
      end
    end

    describe "editing a code group" do
      it do
        group = create(:pathology_code_group, name: "Group1", description: "TheDesc")
        login_as_super_admin

        visit edit_pathology_code_group_path(group)

        expect(page).to have_content "Pathology Code"
        expect(page).to have_content "Group1"

        fill_in "Description", with: "Changed description"
        click_on t("btn.save")

        group.reload
        expect(group.description).to eq("Changed description")
      end
    end
  end
end
