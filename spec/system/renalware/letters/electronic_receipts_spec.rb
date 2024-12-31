describe "View a user's read/unread electronic ccs" do
  include LettersSpecHelper
  let(:patient_family_name) { "GRAVES" }
  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:user_who_is_not_me) { create(:user) }

  let(:completed_letter) { create_letter_with_state(:completed) }
  let(:approved_letter) { create_letter_with_state(:approved) }
  let(:pending_review_letter) { create_letter_with_state(:pending_review) }

  let(:unread_rcpt_for_approved_letter_sent_to_me) do
    create_receipt(read: false, to: me, letter: approved_letter)
  end
  let(:unread_rcpt_for_completed_letter_sent_to_me) do
    create_receipt(read: false, to: me, letter: completed_letter)
  end
  let(:unread_rcpt_for_completed_letter_sent_to_other) do
    create_receipt(read: false, to: user_who_is_not_me, letter: completed_letter)
  end
  let(:unread_rcpt_for_pending_letter_sent_to_me) do
    create_receipt(read: false, to: me, letter: pending_review_letter)
  end
  let(:read_rcpt_for_approved_letter_sent_to_me) do
    create_receipt(read: true, to: me, letter: approved_letter)
  end
  let(:read_rcpt_for_completed_letter_sent_to_me) do
    create_receipt(read: true, to: me, letter: completed_letter)
  end
  let(:read_rcpt_for_completed_letter_sent_to_other) do
    create_receipt(read: true, to: user_who_is_not_me, letter: completed_letter)
  end
  let(:me) { login_as_clinical }

  def create_letter_with_state(state)
    patient = create(
      :letter_patient,
      primary_care_physician: primary_care_physician,
      family_name: SecureRandom.hex(10).upcase
    )
    create_letter(
      to: :patient,
      state: state,
      patient: patient,
      description: "xxx",
      body: SecureRandom.hex(10)
    )
  end

  def create_receipt(letter:, read: false, to: me)
    create(
      :letter_electronic_receipt,
      letter: letter,
      recipient: to,
      read_at: read ? Time.zone.now : nil
    )
  end

  describe "GET unread" do
    it "displays only unread letters which are approved or completed and sent to me" do
      all_receipts = [
        unread_rcpt_for_approved_letter_sent_to_me,
        unread_rcpt_for_completed_letter_sent_to_me,
        unread_rcpt_for_pending_letter_sent_to_me,
        unread_rcpt_for_completed_letter_sent_to_other,
        read_rcpt_for_approved_letter_sent_to_me,
        read_rcpt_for_completed_letter_sent_to_me
      ]

      expected_visible_receipts = [
        unread_rcpt_for_approved_letter_sent_to_me,
        unread_rcpt_for_completed_letter_sent_to_me
      ]

      visit unread_letters_electronic_receipts_path

      all_receipts.each do |receipt|
        selector = "#electronic-receipt-#{receipt.id}"
        if expected_visible_receipts.include?(receipt)
          expect(page).to have_css(selector)
        else
          expect(page).to have_no_css(selector)
        end
      end
    end
  end

  describe "GET read" do
    it "responds successfully" do
      all_receipts = [
        unread_rcpt_for_approved_letter_sent_to_me,
        unread_rcpt_for_completed_letter_sent_to_me,
        unread_rcpt_for_pending_letter_sent_to_me,
        read_rcpt_for_approved_letter_sent_to_me,
        read_rcpt_for_completed_letter_sent_to_me,
        read_rcpt_for_completed_letter_sent_to_other
      ]

      expected_visible_receipts = [
        read_rcpt_for_approved_letter_sent_to_me,
        read_rcpt_for_completed_letter_sent_to_me
      ]

      visit read_letters_electronic_receipts_path

      all_receipts.each do |receipt|
        selector = "#electronic-receipt-#{receipt.id}"
        if expected_visible_receipts.include?(receipt)
          expect(page).to have_css(selector)
        else
          expect(page).to have_no_css(selector)
        end
      end
    end
  end

  describe "GET sent" do
    it "responds successfully" do
      visit sent_letters_electronic_receipts_path

      expect(page.status_code).to eq(200)

      # TODO: Test content
    end
  end
end
