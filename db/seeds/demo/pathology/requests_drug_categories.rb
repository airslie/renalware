module Renalware
  Rails.benchmark "Adding Pathology Requests Drug Categories" do
    file_path = File.join(File.dirname(__FILE__), "requests_drug_categories.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Pathology::Requests::DrugCategory.find_or_create_by!(name: row["name"])
    end
  end
end
