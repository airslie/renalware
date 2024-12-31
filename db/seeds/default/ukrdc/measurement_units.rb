require_relative "../../seeds_helper"

module Renalware
  module UKRDC
    Rails.benchmark "Adding UKRDC measurement units" do
      file_path = File.join(File.dirname(__FILE__), "measurement_units.csv")

      CSV.foreach(file_path, headers: true) do |row|
        MeasurementUnit.find_or_create_by!(name: row["name"]) do |mu|
          mu.description = row["description"]
        end
      end
    end
  end
end
