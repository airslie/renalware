FactoryBot.define do
  factory :hd_slot_request, class: "Renalware::HD::SlotRequest" do
    accountable
    patient
    urgency { "urgent" }
    notes { "some notes" }
  end
end
