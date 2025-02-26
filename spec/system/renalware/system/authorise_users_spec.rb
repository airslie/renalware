require "action_view/record_identifier"

module Renalware
  describe "Authorising, approving and reactivating users" do
    include ActionView::RecordIdentifier
    let(:approved)        { create(:user, :clinical, approved: true) }
    let(:unapproved)      { create(:user, :unapproved) }
    let(:expired)         { create(:user, :expired, :clinical) }
    let(:clinician_role)  { create(:role, :clinical) }

    before do
      clinician_role
      login_as_super_admin
    end

    it "An admin approves a newly registered user" do
      unapproved
      visit admin_users_path
      click_on "Unapproved"

      click_link "Edit"
      expect(page).to have_current_path(edit_admin_user_path(unapproved))

      check "Clinical"
      click_on "Approve"

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(unapproved.reload).to be_approved
      expect(unapproved.roles).to contain_exactly(clinician_role)
    end

    it "An admin tries to approve a user without assigning a role" do
      unapproved
      visit admin_users_path
      click_on "Unapproved"

      click_link "Edit"
      expect(page).to have_current_path(edit_admin_user_path(unapproved))

      click_on "Approve"

      expect(page).to have_current_path(admin_user_path(unapproved))
      expect(unapproved.reload).not_to be_approved
      expect(page).to have_content("User could not be updated")
      expect(page).to have_content(/approved users must have a role/)
    end

    it "An admin saves an unapproved, they want to approve them later (just adding notes now)" do
      unapproved
      visit admin_users_path
      click_on "Unapproved"

      click_link "Edit"
      expect(page).to have_current_path(edit_admin_user_path(unapproved))
      fill_in "Notes", with: "Some notes"

      click_on "Save (approve later)"

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(unapproved.reload).to have_attributes(
        approved: false,
        notes: "Some notes"
      )
    end

    it "An admin removes all roles from a user" do
      approved
      visit admin_users_path

      first("tbody tr##{dom_id(approved)}").click_link("Edit")
      expect(page).to have_current_path(edit_admin_user_path(approved))

      uncheck "Clinical"

      within(".main-content") do
        click_on t("btn.update")
      end

      expect(page).to have_current_path(admin_user_path(approved))
      expect(page).to have_content("User could not be updated")
      expect(page).to have_content(/approved users must have a role/)
    end

    it "An admin gives an existing approved user additional roles" do
      approved
      role_b = create(:role, :prescriber)
      visit admin_users_path

      within("tbody") do
        find("a[href='#{edit_admin_user_path(approved)}']").click
      end
      expect(page).to have_current_path(edit_admin_user_path(approved))

      check "Prescriber"
      click_on t("btn.update")

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(approved.reload).to be_approved
      expect(approved.roles).to include(role_b)
    end

    it "An admin reactivates an inactive user" do
      expired
      visit admin_users_path
      click_link "Inactive"

      first("tbody tr").click_link("Edit")
      expect(page).to have_current_path(edit_admin_user_path(expired))

      check "Reactivate account"
      click_on t("btn.update")

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(expired.reload.expired_at).to be_nil

      click_link "Inactive"

      expect(page).to have_no_content(expired.username)
    end

    it "An admin cannot assign super_admin role to anyone" do
      approved
      visit admin_users_path
      within("tbody") do
        find("a[href='#{edit_admin_user_path(approved)}']").click
      end

      # 'Hidden' super_admin role appears as a disabled checkbox
      expect(find("input[type='checkbox'][disabled='disabled']")).not_to be_nil
    end

    it "An admin cannot remove the super_admin role" do
      superadmin = create(:user, :super_admin)
      visit admin_users_path
      within("tbody") do
        find("a[href='#{edit_admin_user_path(superadmin)}']").click
      end
      expect(page).to have_current_path(edit_admin_user_path(superadmin))

      # may be already unchecked, but just to be sure this person has no roles
      # other than the hidden superadmin role
      uncheck "Clinical"
      click_on t("btn.update")

      # They are as super-admin so submit should succeed and the super-admin
      # role be preserved because that can only be changed on the command line.
      expect(page).to have_current_path(admin_users_path)
      superadmin.reload
      expect(superadmin.role_names).to include("super_admin")
      expect(superadmin.roles).not_to include(clinician_role)
    end
  end
end
