module Renalware
  Rails.benchmark "Adding Pathology Requests Drug Categories Drugs" do
    file_path = File.join(File.dirname(__FILE__), "requests_drugs_drug_categories.csv")

    CSV.foreach(file_path, headers: true) do |row|
      category = Pathology::Requests::DrugCategory.find_by(name: row["drug_category"])
      drug = Pathology::Requests::Drug.find_by(name: row["drug"])

      category.drugs << drug
    end
  end
end
