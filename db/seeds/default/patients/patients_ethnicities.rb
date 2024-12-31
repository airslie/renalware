module Renalware
  Rails.benchmark "Adding Renal Registry Ethnicities" do
    file_path = File.join(File.dirname(__FILE__), "rr18_ethnicity_codes.csv")
    CSV.foreach(file_path, headers: true) do |row|
      Patients::Ethnicity.find_or_create_by!(rr18_code: row["code"]) do |code|
        code.name = row["name"]
        code.cfh_name = row["cfh_name"]
      end
    end
  end
end
