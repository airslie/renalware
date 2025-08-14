FactoryBot.define do
  factory :hd_slot_request, class: "Renalware::HD::SlotRequest" do
    accountable
    patient factory: :hd_patient
    urgency { "urgent" }
    notes { "some notes" }
    location factory: :hd_slot_request_location
    access_state factory: :hd_slot_request_access_state
  end
end
