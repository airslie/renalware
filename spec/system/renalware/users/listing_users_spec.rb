describe "A user views a list of users" do
  it "lists all users in the system" do
    login_as_clinical
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

    visit renalware.users_path

    expect(page).to have_content("Users")
    expect(page).to have_content("Fred Jones")
    expect(page).to have_content("fred@a.com")
    expect(page).to have_content("Dr")
    expect(page).to have_content("Julie Smith")
    expect(page).to have_content("julie@a.com")
    expect(page).to have_content("CEO")
  end
end
