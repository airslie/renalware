module Renalware
  Rails.benchmark "Adding Pathology Request Descriptions" do
    file_path = File.join(File.dirname(__FILE__), "pathology_request_descriptions.csv")
    labs = Pathology::Lab.all.index_by(&:name)

    Pathology::RequestDescription.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        observation_description =
          if row["required_observation_description_code"].present?
            Pathology::ObservationDescription.find_by!(
              code: row["required_observation_description_code"]
            )
          end

        Pathology::RequestDescription.find_or_create_by!(
          code: row["code"],
          name: row["name"],
          lab: labs[row["lab"]],
          required_observation_description: observation_description,
          expiration_days: row["expiration_days"],
          bottle_type: row["bottle_type"]
        )
      end
    end
  end
end
