RSpec.describe "Manage electronic CCs" do
  include LettersSpecHelper

  it "Marks an Electronic CC as `read` for an approved letter", :js do
    user = login_as_clinical
    primary_care_physician = create(:letter_primary_care_physician)
    patient = create(:letter_patient, primary_care_physician:)

    approved_letter = create_letter(
      to: :patient,
      state: :approved,
      patient:,
      description: "xxx"
    )
    create(:letter_electronic_receipt, letter: approved_letter, recipient: user)

    draft_letter = create_letter(
      to: :patient,
      state: :draft,
      patient:,
      description: "yyy"
    )
    create(:letter_electronic_receipt, letter: draft_letter, recipient: user)

    visit dashboard_path

    within ".electronic-ccs" do
      expect(page).to have_text(approved_letter.description)
      expect(page).to have_no_text(draft_letter.description)
      expect(page).to have_css("tbody tr", count: 1)

      click_on t("btn.toggle")
      click_on "Mark as read"

      expect(page).to have_no_text(approved_letter.description)
    end
  end
end
