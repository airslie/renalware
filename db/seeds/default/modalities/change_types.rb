require_relative "../../seeds_helper"

module Renalware
  module Modalities
    Rails.benchmark "Adding modality change types.." do
      user = SystemUser.find
      {
        change_in_modality: {
          name: "Change in modality",
          default: true
        },
        transferred_in: {
          name: "Transferred in",
          require_source_hospital_centre: true
        },
        transferred_out: {
          name: "Transferred out",
          require_destination_hospital_centre: true
        },
        first_ever_dialysis: {
          name: "First ever dialysis"
        },
        other: {
          name: "Other"
        }
      }.each do |code, options|
        ChangeType.find_or_create_by!(code: code, name: name) do |ct|
          ct.assign_attributes(options)
          ct.created_by_id = ct.updated_by_id = user.id
        end
      end
    end
  end
end
