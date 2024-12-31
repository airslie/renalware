require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding HD Cannulation Types" do
    file_path = File.join(File.dirname(__FILE__), "cannulation_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      HD::CannulationType.find_or_create_by!(name: row["name"]) do |ct|
        ct.qhd33_code = row["qhd33_code"]
      end
    end
  end
end
