module Renalware
  Rails.benchmark "Adding Hospital Wards" do
    file_path = File.join(File.dirname(__FILE__), "wards.csv")

    CSV.foreach(file_path, headers: true) do |row|
      unit = Hospitals::Unit.find_by!(unit_code: row["hospital_unit_code"])
      unit.wards.find_or_create_by!(name: row["ward_name"], code: row["ward_code"])
    end
  end
end
