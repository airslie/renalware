require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Tx Investigation Types" do
    file_path = File.join(File.dirname(__FILE__), "investigation_types.csv")
    rows = []
    CSV.foreach(file_path, headers: true) do |row|
      rows << {
        code: row["code"],
        description: row["code"],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Transplants::InvestigationType.upsert_all(rows, unique_by: :code)
  end
end
