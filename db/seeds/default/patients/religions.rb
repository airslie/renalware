module Renalware
  Rails.benchmark "Adding Religions" do
    file_path = File.join(File.dirname(__FILE__), "religions.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Patients::Religion.find_or_create_by!(
        code: row["code"],
        name: row["name"]
      )
    end
  end
end
