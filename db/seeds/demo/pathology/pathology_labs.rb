module Renalware
  Rails.benchmark "Adding Pathology Labs" do
    file_path = File.join(File.dirname(__FILE__), "pathology_labs.csv")

    Pathology::Lab.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        Pathology::Lab.find_or_create_by!(name: row["name"])
      end
    end
  end
end
