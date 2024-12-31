module Renalware
  Rails.benchmark "Adding Abridged Patients" do
    return if Patients::Abridgement.any?

    file_path = Rails.root.join(File.dirname(__FILE__), "abridgements.csv")
    abridgements = CSV.foreach(file_path, headers: true).map do |row|
      {
        hospital_number: row["hospital_number"],
        family_name: row["family_name"],
        given_name: row["given_name"],
        born_on: row["born_on"],
        sex: row["sex"],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Patients::Abridgement.insert_all(abridgements)
  end
end
