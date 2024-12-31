require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding comorbidity descriptions" do
    file_path = File.join(File.dirname(__FILE__), "comorbidity_descriptions.csv")
    descriptions = CSV.foreach(file_path, headers: true).map do |row|
      {
        name: row["name"],
        position: row["position"],
        snomed_code: row["snomed_code"],
        has_malignancy_site: row["has_malignancy_site"],
        has_diabetes_type: row["has_diabetes_type"],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Problems::Comorbidities::Description.upsert_all(descriptions, unique_by: :name)
  end
end
