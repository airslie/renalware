# frozen_string_literal: true

describe "Managing downloads - files uploaded by super admins which can be accessed by any user" do
  it "creating a new download" do
    login_as_super_admin
    visit new_system_download_path
    fill_in "Name", with: "Low sodium dietry advice"
    fill_in "Description", with: "A description"
    attach_file "File", file_fixture("dog.jpg")

    click_on t("btn.create")

    download = Renalware::System::Download.last
    expect(download).to have_attributes(
      name: "Low sodium dietry advice",
      description: "A description"
    )
    expect(download.file).to be_attached
  end

  it "editing a download" do
    login_as_super_admin
    create(:system_download, :with_file, name: "Name1", description: "Description1")
    visit system_downloads_path
    within(".download") { click_on t("btn.edit") }

    fill_in "Name", with: "Updated name"
    click_on t("btn.save")

    within(".download") do
      expect(page).to have_content("Updated name")
    end
  end

  it "deleting a download" do
    login_as_super_admin
    create(:system_download, :with_file, name: "Name1", description: "Description1")
    visit system_downloads_path
    within(".download") { click_on t("btn.delete") }

    expect(page).to have_no_css(".download")
  end

  it "listing items" do
    login_as_super_admin
    create(:system_download, :with_file, name: "Name1", description: "Description1")
    visit system_downloads_path

    expect(page).to have_content("Name1")
    expect(page).to have_content("Description1")
    expect(page).to have_content("View")
  end

  it "filtering items" do
    login_as_super_admin
    create(:system_download, :with_file, name: "Name1", description: "Description1")
    create(:system_download, :with_file, name: "Name2", description: "Description2")
    visit system_downloads_path

    expect(page).to have_css(".download", count: 2)

    within ".filters" do
      fill_in "q_name_or_description_cont", with: "Name2"
      click_on "Filter"
    end

    expect(page).to have_css(".download", count: 1)
    expect(page).to have_content("Description2")
  end

  describe "viewing an attachment" do
    it "clicking on the name opens the attachment in a new window using & increments view_count" do
      login_as_super_admin
      item = create(:system_download, :with_file, name: "Name1", description: "Description1")
      visit system_downloads_path

      within(".download") do
        click_on "Name1"
      end

      expect(page).to have_current_path(%r{rails/active_storage.*})
      expect(item.reload.view_count).to eq(1)
    end
  end
end
