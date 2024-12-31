require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Default Event Categories" do
    Events::Category.find_or_create_by!(name: "General") do |category|
      category.position = 1
    end
  end
end
