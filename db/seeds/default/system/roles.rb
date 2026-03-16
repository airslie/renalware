require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Roles" do
    Role.install!

    %i(read_only clinical).each do |role_name|
      Role.find_by!(name: role_name).update!(ad_role_name: role_name.to_s.camelize)
    end
  end
end
