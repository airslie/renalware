module Renalware
  Rails.benchmark "Adding PD Systems" do
    file_path = File.join(File.dirname(__FILE__), "systems.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::System.find_or_create_by!(name: row["name"], pd_type: row["pd_type"])
    end
  end
end
