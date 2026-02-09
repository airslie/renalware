module Renalware
  Rails.benchmark "Adding Pathology Request Algorithm Patient Rules" do
    file_path = File.join(File.dirname(__FILE__), "request_algorithm_patient_rules.csv")

    CSV.foreach(file_path, headers: true) do |row|
      lab = Pathology::Lab.find_by(name: row["lab"])

      Pathology::Requests::PatientRule.find_or_create_by!(
        lab: lab,
        test_description: row["test_description"],
        sample_number_bottles: row["sample_number_bottles"],
        sample_type: row["sample_type"],
        frequency_type: row["frequency_type"],
        patient_id: row["patient_id"],
        start_date: row["start_date"],
        end_date: row["end_date"]
      )
    end
  end
end
