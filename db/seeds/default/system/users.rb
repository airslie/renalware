require_relative "../../seeds_helper"

module Renalware
  include SeedsHelper

  Rails.benchmark "Adding System User" do
    ensure_factory_bot_loaded

    FactoryBot.create(
      :user,
      :find_or_create,
      given_name: "System",
      family_name: "User",
      username: Renalware::SystemUser.username,
      password: "P!#{SecureRandom.hex(20)}",
      email: "systemuser@renalware.net",
      approved: true,
      signature: "System User",
      role: :super_admin
    )
  end
end
