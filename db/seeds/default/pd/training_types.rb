module Renalware
  Rails.benchmark "Adding PD Training Types" do
    file_path = File.join(File.dirname(__FILE__), "training_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::TrainingType.find_or_create_by!(name: row["name"])
    end
  end
end
