describe Renalware::Letters::LettersInProgressComponent, type: :component do
  include LettersSpecHelper

  context "when the user has no letters in progress" do
    it "displays a message saying as much" do
      user = login_as_clinical
      render_inline(described_class.new(current_user: user))

      expect(page).to have_content("Letters in progress")
    end
  end

  context "when the user has letters in progress" do
    it "displays them - it also calls #policy so in specs exercises Warden" do
      user = login_as_clinical
      patient = create(:letter_patient, by: user)
      create_letter(state: :draft, to: :patient, patient: patient, by: user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_content("Letters in progress")
    end
  end
end
