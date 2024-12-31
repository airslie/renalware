describe Renalware::Letters::UnreadElectronicCCsComponent, type: :component do
  include LettersSpecHelper

  def send_letter_ecc_to(user)
    author = create(:user)
    patient = create(:letter_patient)
    letter = create_letter(state: :approved, to: :patient, patient: patient, by: author)
    letter.electronic_cc_recipients << user
    letter.save_by!(author)
    letter
  end

  context "when a user has unread eCCs" do
    it "displays the user's eCCs" do
      user = create(:user)
      letter = send_letter_ecc_to(user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_content("Electronic CCs")
      expect(page).to have_content(letter.description)
    end
  end

  context "when a user has no eCCs" do
    it "displays a no messages message" do
      user = create(:user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_content("Electronic CCs")
      expect(page).to have_content("You have no electronic CCs")
    end
  end
end
