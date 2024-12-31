FactoryBot.define do
  factory :hd_slot_request_deletion_reason, class: "Renalware::HD::SlotRequests::DeletionReason" do
    reason { "Some Reason" }
  end
end
