require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding System User" do
    Renalware::User.find_or_create_by!(given_name: "System", family_name: "User") do |user|
      user.username = Renalware::SystemUser.username
      user.password = "P!#{SecureRandom.hex(20)}"
      user.email = "systemuser@renalware.net"
      user.roles = [Renalware::Role.find_by!(name: :super_admin)]
      user.approved = true
      user.signature = "System User"
    end
  end
end
