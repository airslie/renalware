module Renalware
  describe "Managing nag definitions" do
    describe "Displaying a list of nag definitions" do
      it do
        login_as_super_admin
        nag_def = System::NagDefinition.create(
          description: "Check patient has ESRF date",
          scope: :patient,
          importance: 1,
          sql_function_name: "x",
          title: "Hey!"
        )

        visit system_nag_definitions_path

        expect(page).to have_content nag_def.importance
        expect(page).to have_content nag_def.description
        expect(page).to have_content nag_def.sql_function_name
        expect(page).to have_content nag_def.title
      end
    end

    describe "Adding a nag definition" do
      it do
        login_as_super_admin

        visit system_nag_definitions_path

        within ".page-heading" do
          click_on "Add"
        end

        # This function is present as there is a migration that defines it, so its
        # safe to reference in this spec.
        select "patient_nag_clinical_frailty_score", from: "Sql function name"
        fill_in "Description", with: "Desc"
        fill_in "Title", with: "Title"
        fill_in "Importance", with: "10"
        fill_in "Hint", with: "Hey"
        fill_in "Relative link", with: "/path"

        click_on "Create"

        expect(page).to have_current_path(system_nag_definitions_path)

        expect(Renalware::System::NagDefinition.last).to have_attributes(
          description: "Desc",
          title: "Title",
          importance: 10,
          hint: "Hey",
          sql_function_name: "patient_nag_clinical_frailty_score",
          relative_link: "/path"
        )
      end
    end
  end
end
