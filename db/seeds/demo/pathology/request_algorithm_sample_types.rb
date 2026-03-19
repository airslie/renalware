module Renalware
  Rails.benchmark "Adding Pathology Request Algorithm Sample Types" do
    file_path = File.join(File.dirname(__FILE__), "request_algorithm_sample_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Pathology::Requests::SampleType.find_or_create_by!(
        code: row["code"],
        name: row["name"]
      )
    end
  end
end
