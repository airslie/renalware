require_relative "../../seeds_helper"

module Renalware
  module UKRDC
    Rails.benchmark "Adding UKRDC assessment types" do
      file_path = File.join(File.dirname(__FILE__), "assessment_types.csv")

      CSV.foreach(file_path, headers: true) do |row|
        Assessments::Type.find_or_create_by!(code: row["code"]) do |at|
          at.description = row["description"]
        end
      end
    end
  end
end
