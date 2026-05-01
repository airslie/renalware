# A letter is approved when it has been "reviewed" by the doctor. An approved letter
# cannot be modified, and the content and visual presentation are stored permanently
# for legal purposes (archive).

# An approved letter can be viewed in a browser and downloaded as a PDF.

# A letter is considered electronically signed at the moment the user approves it.
# It can be signed by another doctor who is not assigned to the patient in the case
# the assigned doctor is absent (e.g. on vacation).

RSpec.describe "Approving a letter", :js do
  let(:doctor) { create(:user, :clinical) }
  let(:nurse) { create(:user, :clinical) }
  let(:patient) { letter.patient }
  let(:letter) { create(:pending_review_letter) }

  it "is approved by a doctor" do
    login_as doctor
    visit patient_letters_letter_path(patient, letter)

    accept_alert { click_on "Approve and archive" }

    expect(page).to have_text "Approved"

    letter = Renalware::Letters::Letter.last
    expect(letter).to be_signed
    expect(letter).to be_archived
    expect(letter.archive).to be_present

    expect(letter.class.policy_class.new(doctor, letter)).not_to be_update
  end
end
