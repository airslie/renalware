require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Pathology Code Groups" do
    user = User.first
    Pathology::CodeGroup.find_or_create_by!(name: "hd_session_form_recent") do |group|
      group.description = "Recent pathology shown on the HD Sessions printable form"
      group.title = "HD Session printable form"
      group.context_specific = true
      group.created_by = user
      group.updated_by = user

      # We could add observation_descriptions to the group here but none are seeded in the
      # default seeds.
    end
  end
end
