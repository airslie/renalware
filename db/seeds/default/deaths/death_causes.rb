require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Renal Reg Cause of Death codes" do
    file_path = File.join(File.dirname(__FILE__), "death_causes.csv")
    causes = CSV.foreach(file_path, headers: true).map do |row|
      {
        code: row["code"],
        description: row["description"],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Deaths::Cause.upsert_all(causes, unique_by: :code)
  end
end
