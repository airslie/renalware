# frozen_string_literal: true

require "action_view/record_identifier"

module Renalware
  describe "Authorising, approving and reactivating users" do
    include ActionView::RecordIdentifier

    before do
      @clinician_role = Role.find_or_create_by(name: "clinical")
      @approved = create(:user)
      @unapproved = create(:user, :unapproved)
      @expired = create(:user, :expired, :clinical)

      login_as_super_admin

      visit admin_users_path
    end

    it "An admin approves a newly registered user" do
      click_on "Unapproved"

      click_link "Edit"
      expect(page).to have_current_path(edit_admin_user_path(@unapproved))

      check "Clinical"
      click_on "Approve"

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(@unapproved.reload).to be_approved
      expect(@unapproved.roles).to contain_exactly(@clinician_role)
    end

    it "An admin approves a user without assigning a role" do
      click_on "Unapproved"

      click_link "Edit"
      expect(page).to have_current_path(edit_admin_user_path(@unapproved))

      click_on "Approve"

      expect(page).to have_current_path(admin_user_path(@unapproved))
      expect(@unapproved.reload).not_to be_approved
      expect(page).to have_content("User could not be updated")
      expect(page).to have_content(/approved users must have a role/)
    end

    it "An admin removes all roles from a user" do
      first("tbody tr##{dom_id(@approved)}").click_link("Edit")
      expect(page).to have_current_path(edit_admin_user_path(@approved))

      uncheck "Clinical"
      click_on t("btn.update")

      expect(page).to have_current_path(admin_user_path(@approved))
      expect(page).to have_content("User could not be updated")
      expect(page).to have_content(/approved users must have a role/)
    end

    it "An admin authorises an existing user with additional roles" do
      within("tbody") do
        find("a[href='#{edit_admin_user_path(@approved)}']").click
      end
      expect(page).to have_current_path(edit_admin_user_path(@approved))

      check "Clinical"
      click_on t("btn.update")

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(@approved.reload).to be_approved
      expect(@approved.roles).to include(@clinician_role)
    end

    it "An admin reactivates an inactive user" do
      click_link "Inactive"

      first("tbody tr").click_link("Edit")
      expect(page).to have_current_path(edit_admin_user_path(@expired))

      check "Reactivate account"
      click_on t("btn.update")

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content("User updated")
      expect(@expired.reload.expired_at).to be_nil

      click_link "Inactive"

      expect(page).to have_no_content(@expired.username)
    end

    it "An admin cannot assign super_admin role to anyone" do
      within("tbody") do
        find("a[href='#{edit_admin_user_path(@approved)}']").click
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
      expect(superadmin.roles).not_to include(@clinician_role)
    end
  end
end
