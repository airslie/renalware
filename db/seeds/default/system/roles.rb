require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Roles" do
    Role.install!
  end
end
