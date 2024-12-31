require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Transplant Donor Stage Positions" do
    names = [
      "Currently Active",
      "Active Workup but on Hold",
      "Not Currently Active",
      "Unsuitable - clinical",
      "Unsuitable - declined",
      "Ready",
      "Kidney Donated"
    ]

    names.each_with_index do |name, index|
      Transplants::DonorStagePosition.find_or_create_by(
        name: name,
        position: index * 10
      )
    end
  end

  Rails.benchmark "Adding Transplant Donor Stage Statuses" do
    names = [
      "Initial Contact",
      "Initial Meeting / Tests",
      "Extended Assessment",
      "Awaiting HTA",
      "Completed / Ready"
    ]

    names.each_with_index do |name, index|
      Transplants::DonorStageStatus.find_or_create_by(
        name: name,
        position: index * 10
      )
    end
  end
end
