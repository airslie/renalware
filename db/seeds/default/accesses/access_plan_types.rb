require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Access Plan Types" do
    file_path = File.join(File.dirname(__FILE__), "access_plan_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Accesses::PlanType.find_or_create_by!(name: row["name"])
    end
  end
end
