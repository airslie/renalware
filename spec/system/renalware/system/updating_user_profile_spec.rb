module Renalware
  describe "Updating user profile" do
    before do
      @clinician = login_as_clinical
      visit edit_user_registration_path(@clinician)
    end

    it "updating professional position and signature" do
      fill_in "Professional position", with: "Renal Nurse"
      fill_in "Signature", with: "Dr. X, Y Z"
      fill_in "Current password", with: @clinician.password
      click_on t("btn.save")

      expect(page).to have_current_path(root_path)
      expect(page).to have_content("You updated your account successfully")
      expect(@clinician.reload.professional_position).to eq("Renal Nurse")
      expect(@clinician.signature).to eq("Dr. X, Y Z")
    end

    it "updating with no signature or professional position" do
      fill_in "Signature", with: ""
      fill_in "Professional position", with: ""
      fill_in "Current password", with: @clinician.password
      click_on t("btn.save")

      expect(page).to have_content("Professional position can't be blank")
      expect(page).to have_content("Signature can't be blank")
    end

    context "when LDAP authentication is enabled" do
      let(:ldap_adapter) { instance_double(Ldap::Connection) }

      before do
        allow(Renalware.config).to receive(:ldap_authentication_enabled?).and_return(true)
        allow(Ldap::Connection).to receive(:new).and_return(ldap_adapter)
      end

      it "validates current password against LDAP" do
        allow(ldap_adapter).to receive(:valid_credentials?)
          .and_return(true)

        fill_in "Professional position", with: "Senior Nurse"
        fill_in "Signature", with: "Jane Smith, RN"
        fill_in "Current password", with: "correct_ldap_password"
        click_on t("btn.save")

        expect(page).to have_current_path(root_path)
        expect(page).to have_content("You updated your account successfully")
        expect(@clinician.reload.professional_position).to eq("Senior Nurse")
        expect(@clinician.signature).to eq("Jane Smith, RN")
      end

      it "rejects update with incorrect LDAP password" do
        allow(ldap_adapter).to receive(:valid_credentials?)
          .and_return(false)

        fill_in "Professional position", with: "Senior Nurse"
        fill_in "Signature", with: "Jane Smith, RN"
        fill_in "Current password", with: "wrong_password"
        click_on t("btn.save")

        expect(page).to have_content("Current password is invalid")
        expect(@clinician.reload.professional_position).not_to eq("Senior Nurse")
      end
    end
  end
end
