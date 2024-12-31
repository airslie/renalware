describe "Managing user feedback" do
  it "adding notes and acknowledgement to feedback" do
    user = login_as_super_admin
    create(:user_feedback, author: user, comment: "My comment is..")
    visit system_user_feedback_index_path

    expect(page).to have_content "Feedback"
    within "table.feedback" do
      expect(page).to have_content "My comment is"
      expect(page).to have_content user.to_s
      click_on t("btn.edit")
    end

    expect(page).to have_content("My comment is")
    expect(page).to have_content(user.to_s)
    fill_in "Admin notes", with: "My notes"
    check "Acknowledged"
    click_on t("btn.save")

    expect(page).to have_current_path(system_user_feedback_index_path)
  end
end
