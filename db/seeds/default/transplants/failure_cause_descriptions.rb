require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Failure Causes" do
    file_path = File.join(File.dirname(__FILE__), "failure_cause_descriptions.csv")

    CSV.foreach(file_path, headers: true) do |row|
      group = Transplants::FailureCauseDescriptionGroup.find_or_create_by!(name: row["group"])

      Transplants::FailureCauseDescription.find_or_create_by!(code: row["code"]) do |cause|
        cause.group = group
        cause.name = row["name"]
      end
    end
  end
end
