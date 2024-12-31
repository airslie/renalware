module Renalware
  Rails.benchmark "Adding Hospitals" do
    file_path = File.join(File.dirname(__FILE__), "hospitals.csv")

    Hospitals::Centre.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        Hospitals::Centre.find_or_create_by!(code: row["code"]) do |hospital|
          hospital.name = row["name"]
          hospital.abbrev = row["abbrev"]
          hospital.host_site = row["host_site"] == "true"
          hospital.location = row["location"]
          hospital.active = true
          hospital.is_transplant_site = (row["is_transplant_site"] == "1")
          hospital.trust_name = row["trust_name"]
          hospital.trust_caption = row["trust_caption"]
          hospital.info = row["info"],
          hospital.position = row["position"] || 99
        end
      end
    end
  end
end
