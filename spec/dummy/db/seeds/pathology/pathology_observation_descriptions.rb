module Renalware
  log "Adding Pathology Observation Descriptions" do

    file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")

    CSV.foreach(file_path, headers: true) do |row|
      measurement_unit_name = row["unit_of_measurement"]
      measurement_unit_id = if measurement_unit_name.present?
                              Pathology::MeasurementUnit.find_by(name: measurement_unit_name).id
                            else
                              nil
                            end
      Pathology::ObservationDescription.find_or_create_by!(
        code: row["code"],
        name: row["name"],
        measurement_unit_id: measurement_unit_id,
        loinc_code: row["loinc_code"]
      )
    end
  end
end
