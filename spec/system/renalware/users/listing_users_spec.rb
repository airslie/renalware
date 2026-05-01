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

    visit users_path

    expect(page).to have_text("Users")
    expect(page).to have_text("Fred Jones")
    expect(page).to have_text("fred@a.com")
    expect(page).to have_text("Dr")
    expect(page).to have_text("Julie Smith")
    expect(page).to have_text("julie@a.com")
    expect(page).to have_text("CEO")
  end
end
