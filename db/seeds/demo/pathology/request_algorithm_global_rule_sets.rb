module Renalware
  Rails.benchmark "Adding Pathology Request Algorithm Global Rule Sets" do
    file_path = File.join(File.dirname(__FILE__), "request_algorithm_global_rule_sets.csv")

    CSV.foreach(file_path, headers: true) do |row|
      clinic = ::Renalware::Clinics::Clinic.find_by(name: row["clinic"])
      request_description = Pathology::RequestDescription.find_by(
        code: row["request_description_code"]
      )

      Pathology::Requests::GlobalRuleSet.find_or_create_by!(
        id: row["id"],
        clinic: clinic,
        request_description: request_description,
        frequency_type: row["frequency_type"]
      )
    end
  end
end
