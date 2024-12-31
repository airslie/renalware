module Renalware
  Rails.benchmark "Adding HD Station Locations" do
    file_path = File.join(File.dirname(__FILE__), "station_locations.csv")
    CSV.foreach(file_path, headers: true) do |row|
      HD::StationLocation.find_or_create_by!(name: row["name"], colour: row["colour"])
    end
  end
end
