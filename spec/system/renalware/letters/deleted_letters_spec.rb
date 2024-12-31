describe "Soft-deleted letter administration" do
  include LettersSpecHelper
  let(:user) { create(:user, :clinical) }
  let(:superadmin) { create(:user, :super_admin) }
  let(:patient1) { create(:letter_patient, by: user, family_name: "PATIENT1") }
  let(:patient2) { create(:letter_patient, by: user, family_name: "PATIENT2") }

  describe "viewing a list of deleted letters" do
    it "shows only soft-deleted letters and who deleted them and when" do
      create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
        patient: patient1
      )
      deleted_letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
        patient: patient2
      )
      Renalware::Letters::DeleteLetter.call(letter: deleted_letter, by: user)
      deleted_letter.reload

      login_as superadmin
      visit letters_list_path

      expect(page).to have_content(patient1.family_name)
      expect(page).to have_no_content(patient2.family_name)

      within(".sub-nav") do
        click_on "Deleted"
      end

      expect(page).to have_current_path(renalware.letters_deleted_path)
      expect(page).to have_content(patient2.family_name)
      expect(page).to have_no_content(patient1.family_name)
      expect(page).to have_content(deleted_letter.deleted_by)
      expect(page).to have_content(I18n.l(deleted_letter.deleted_at))
    end
  end
end
