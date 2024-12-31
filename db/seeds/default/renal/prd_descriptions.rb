require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Primary Renal Diagnosis (PRD) Codes" do
    file_path = File.join(File.dirname(__FILE__), "prd_descriptions.csv")
    descriptions = CSV.foreach(file_path, headers: true).map do |row|
      {
        code: row["code"],
        term: row["term"],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Renal::PRDDescription.upsert_all(descriptions, unique_by: :code)
  end
end
