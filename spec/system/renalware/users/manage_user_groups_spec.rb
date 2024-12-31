describe "A superadmin lists groups", :js do
  it "lists all user groups in the system" do
    user = login_as_super_admin
    create(
      :user,
      family_name: "Jones",
      given_name: "Fred",
      email: "fred@a.com",
      professional_position: "Dr"
    )
    create(
      :user,
      family_name: "Smith",
      given_name: "Julie",
      email: "julie@a.com",
      professional_position: "CEO"
    )

    Renalware::Users::Group.create!(name: "G1", description: "abc", by: user)
    Renalware::Users::Group.create!(name: "G2", description: "xyz", by: user)

    visit renalware.user_groups_path

    expect(page).to have_content("User Groups")
    expect(page).to have_content("G1")
    expect(page).to have_content("G2")
  end

  it "add a group" do
    login_as_super_admin
    another_user = create(:user, :clinical)
    visit renalware.user_groups_path
    within ".page-actions" do
      click_on "Add"
    end

    fill_in "Name", with: "Group1"
    fill_in "Description", with: "abc"
    slim_select another_user.to_s, from: "Users"
    click_on "Create"

    expect(page).to have_current_path(renalware.user_groups_path)
    expect(page).to have_content("Group1")
    expect(page).to have_content(another_user.to_s)

    expect(Renalware::Users::Group.first.users).to eq([another_user])
  end

  it "edit a group, adding a user" do
    user = login_as_super_admin
    another_user = create(:user)
    group = Renalware::Users::Group.create!(name: "Group1", by: user)
    visit renalware.user_groups_path

    within("##{dom_id(group)}") do
      click_on "Edit"
    end
    fill_in "Name", with: "GroupX"
    fill_in "Description", with: "abc"
    slim_select another_user.to_s, from: "Users"
    click_on "Save"

    expect(page).to have_current_path(renalware.user_groups_path)
    expect(page).to have_content("GroupX")
    expect(page).to have_content(another_user.to_s)

    expect(group.users).to eq([another_user])
  end
end
