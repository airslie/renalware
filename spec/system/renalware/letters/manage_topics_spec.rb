describe "Manage letter topics" do
  it "enables a superadmin to list letter topics" do
    login_as_super_admin
    topic = create(:letter_topic, text: "LD1")

    visit letters_topics_path

    expect(page).to have_content("Letter Topics")
    expect(page).to have_content(topic.text)
  end

  it "enables a superadmin to add a letter topic" do
    login_as_super_admin

    visit letters_topics_path

    within ".page-heading" do
      click_on "Add"
    end

    fill_in "Text", with: "LD123"
    choose "Haemodialysis"
    click_on "Create"

    within "table" do
      expect(page).to have_content("LD123")
      expect(page).to have_content("HD")
      expect(page).to have_content I18n.l(Renalware::Letters::Topic.last.created_at)
    end
  end

  it "enables a superadmin to edit a letter topic" do
    topic = create(:letter_topic, text: "LD1")
    login_as_super_admin

    visit letters_topics_path

    within "#letters_topic_#{topic.id}" do
      click_on "Edit"
    end

    fill_in "Text", with: "LD2"
    choose "Acute Kidney Care Clinic"
    click_on "Save"

    within "table" do
      expect(page).to have_content("LD2")
      expect(page).to have_content("AKCC")
    end

    expect(topic.reload).to have_attributes(text: "LD2", section_identifier: "akcc")
  end

  it "enables a superadmin to soft-delete a letter topic" do
    login_as_super_admin
    topic = create(:letter_topic, text: "LD1")

    visit letters_topics_path

    within "#letters_topic_#{topic.id}" do
      click_on "Delete"
    end

    expect(Renalware::Letters::Topic.count).to eq(0)
    expect(Renalware::Letters::Topic.with_deleted.first.deleted_at).not_to be_nil
  end
end
