module Renalware
  Rails.benchmark "Adding Languages" do
    file_path = File.join(File.dirname(__FILE__), "patients_languages.csv")
    languages = CSV.foreach(file_path, headers: true).map do |row|
      Patients::Language.new(code: row["code"], name: row["name"])
      {
        code: row["code"],
        name: row["name"]
      }
    end
    Patients::Language.upsert_all(languages, unique_by: :code)
  end
end
