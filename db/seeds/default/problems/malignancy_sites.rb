require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding malignancy sites" do
    file_path = File.join(File.dirname(__FILE__), "malignancy_sites.csv")
    malignancy_sites = CSV.foreach(file_path, headers: true).map do |row|
      row.to_h.symbolize_keys
    end
    Problems::MalignancySite.upsert_all(malignancy_sites, unique_by: :description)
  end
end
