module Renalware
  Rails.benchmark "Adding HD Slot Request Locations" do
    # These are based on what's in use at BLT
    HD::SlotRequests::Location.find_or_create_by!(name: "9E")
    HD::SlotRequests::Location.find_or_create_by!(name: "9F")
    HD::SlotRequests::Location.find_or_create_by!(name: "Renal ECU")
    HD::SlotRequests::Location.find_or_create_by!(name: "RLH outlier")
    HD::SlotRequests::Location.find_or_create_by!(name: "Outpatient")
    HD::SlotRequests::Location.find_or_create_by!(name: "Other")
  end
end
