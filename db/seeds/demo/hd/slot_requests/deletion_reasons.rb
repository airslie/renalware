module Renalware
  Rails.benchmark "Adding HD Slot Request Deletion Reasons" do
    HD::SlotRequests::DeletionReason.find_or_create_by!(reason: "Deceased")
    HD::SlotRequests::DeletionReason.find_or_create_by!(reason: "Recovered")
    HD::SlotRequests::DeletionReason.find_or_create_by!(reason: "Started PD")
    HD::SlotRequests::DeletionReason.find_or_create_by!(reason: "Transplanted")
    HD::SlotRequests::DeletionReason.find_or_create_by!(reason: "Transferred out")
    HD::SlotRequests::DeletionReason.find_or_create_by!(reason: "Other")
  end
end
