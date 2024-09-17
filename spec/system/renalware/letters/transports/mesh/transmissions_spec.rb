# frozen_string_literal: true

# describe "ToC queued letter management" do
#   include LettersSpecHelper
#   let(:user) { create(:user) }
#   let(:practice) { create(:practice) }

#   def create_patient(given_name: "John")
#     create(
#       :letter_patient,
#       given_name: given_name, # trigger value
#       practice: practice,
#       primary_care_physician: create(:letter_primary_care_physician, practices: [practice]),
#       by: user
#     )
#   end

#   def enqueue(letter)
#     Renalware::Letters::ApproveLetter
#       .build(letter)
#       .call(by: user)
#     Renalware::Letters::Transports::TransferOfCare::Operation.create!(
#       letter_id: letter.id
#     )
#   end

#   # it "allows listing outgoing docs for a superadmin" do
#   #   patient = create_patient
#   #   letter = create_letter(
#   #     state: :pending_review,
#   #     to: :primary_care_physician,
#   #     patient: patient,
#   #     author: user,
#   #     by: user
#   #   ).reload

#   #   message = enqueue(letter)

#   #   # queued_letter.to_typed_instance.reload # refreshes the UUID which was gen
#   #   login_as_super_admin

#   #   visit letters_delivery_toc_messages_path

#   #   expect(page).to have_content("Transfer Of Care Letter Queue")
#   #   # expect(page).to have_content(user.to_s)
#   #   # expect(page).to have_content(doc.id)
#   #   # expect(page).to have_content(doc.state)
#   # end
# end
