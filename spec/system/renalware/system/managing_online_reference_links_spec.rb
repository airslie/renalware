# frozen_string_literal: true

module Renalware
  describe "Managing online reference links" do
    let(:user) { create(:user) }

    describe "Displaying a list" do
      it do
        login_as_admin
        reference = System::OnlineReferenceLink.create!(
          title: "Title1",
          url: "http://example.com/1",
          description: "Description1",
          by: user
        )

        visit system_online_reference_links_path

        expect(page).to have_content reference.url
        expect(page).to have_content reference.title
        expect(page).to have_content reference.description
      end
    end

    describe "Adding a reference" do
      it do
        login_as_admin

        visit system_online_reference_links_path

        within ".page-heading" do
          click_on "Add"
        end

        # This function is present as there is a migration that defines it, so its
        # safe to reference in this spec.

        fill_in "Title", with: "Title"
        fill_in "Description", with: "Desc"
        fill_in "URL", with: "https://example.com/2"
        fill_in "From", with: "2024-01-01"
        fill_in "To", with: "2024-01-02"

        click_on "Save"

        expect(page).to have_current_path(system_online_reference_links_path)

        expect(Renalware::System::OnlineReferenceLink.last).to have_attributes(
          description: "Desc",
          title: "Title",
          url: "https://example.com/2",
          include_in_letters_from: Date.parse("2024-01-01"),
          include_in_letters_until: Date.parse("2024-01-02")
        )
      end
    end

    describe "Editing a reference" do
      it do
        reference = System::OnlineReferenceLink.create!(
          title: "Title1",
          url: "http://example.com/1",
          description: "Description1",
          by: user
        )

        login_as_admin

        visit system_online_reference_links_path

        within "##{dom_id(reference)}" do
          click_on "Edit"
        end

        # This function is present as there is a migration that defines it, so its
        # safe to reference in this spec.

        fill_in "Title", with: "Title"
        fill_in "Description", with: "Desc"
        fill_in "URL", with: "https://example.com/2"

        click_on "Save"

        expect(page).to have_current_path(system_online_reference_links_path)

        expect(Renalware::System::OnlineReferenceLink.last).to have_attributes(
          description: "Desc",
          title: "Title",
          url: "https://example.com/2"
        )
      end
    end
  end
end
