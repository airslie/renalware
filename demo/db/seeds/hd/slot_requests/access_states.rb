module Renalware
  Rails.benchmark "Adding HD Slot Request Access States" do
    HD::SlotRequests::AccessState.find_or_create_by!(name: "Working AVF/AVG")
    HD::SlotRequests::AccessState.find_or_create_by!(name: "THL")
    HD::SlotRequests::AccessState.find_or_create_by!(name: "Pending (see notes)")
  end
end
