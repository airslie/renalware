module Renalware
  # Rails.benchmark "Adding Drugs" do
  #   file_path = File.join(File.dirname(__FILE__), "drugs.csv")
  #   drugs = CSV.foreach(file_path, headers: true).map do |row|
  #     {
  #       name: row["name"],
  #       created_at: Time.zone.now,
  #       updated_at: Time.zone.now
  #     }
  #   end
  #   Drugs::Drug.insert_all(drugs)
  # end

  Rails.benchmark "Adding Vaccination drugs" do
    vaccination_drug_type = Drugs::Type.find_by!(code: "vaccine")
    [
      "HBVAXPRO 40 micrograms (hepatitis B vaccine)",
      "Pfizer-BioNTech COVID-19 Vaccine",
      "ChAdOx1 nCoV-19 Vaccine"
    ].each do |name|
      drug = Drugs::Drug.find_or_create_by!(name: name)
      drug.drug_types << vaccination_drug_type
      drug.save!
    end
  end
end
