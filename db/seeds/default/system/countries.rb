require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Countries" do
    file_path = File.join(File.dirname(__FILE__), "countries.csv")
    countries = CSV.foreach(file_path, headers: true).map.each_with_index do |row, index|
      {
        name: row["name"],
        alpha2: row["alpha2"],
        alpha3: row["alpha3"],
        position: index
      }
    end
    System::Country.upsert_all(countries, unique_by: :name)
  end
end
