require_relative "../../seeds_helper"

module Renalware
  module UKRDC
    Rails.benchmark "Adding UKRDC assessment outcomes" do
      file_path = File.join(File.dirname(__FILE__), "assessment_outcomes.csv")

      CSV.foreach(file_path, headers: true) do |row|
        Assessments::Outcome.find_or_create_by!(code: row["code"]) do |at|
          at.description = row["description"]
          at.assessment_type = Assessments::Type.find_by!(code: row["assessment_type"])
        end
      end
    end
  end
end
