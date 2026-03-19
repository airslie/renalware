module Renalware
  Rails.benchmark "Adding Pathology Observation Descriptions" do
    file_path = File.join(File.dirname(__FILE__), "pathology_observation_descriptions.csv")
    units_of_measurement_map = Renalware::Pathology::MeasurementUnit.select(:id, :name)
      .each_with_object({}) { |uom, hash| hash[uom.name] = uom.id }

    Pathology::ObservationDescription.transaction do
      descriptions = CSV.foreach(file_path, headers: true).map do |row|
        {
          code: row["code"],
          name: row["name"],
          measurement_unit_id: units_of_measurement_map[row["unit_of_measurement"]],
          virtual: false,
          loinc_code: row["loinc_code"],
          display_group: row["display_group"],
          display_order: row["display_order"],
          letter_group: row["letter_group"],
          letter_order: row["letter_order"],
          colour: row["colour"],
          chart_sql_function_name: nil,
          chart_colour: nil,
          chart_logarithmic: false,
          created_at: Time.zone.now,
          updated_at: Time.zone.now
        }
      end

      descriptions << {
        code: "PRODUCT CA PHOS",
        name: "Product of CA and PHOS",
        measurement_unit_id: nil,
        virtual: true,
        loinc_code: nil,
        display_group: nil,
        display_order: nil,
        letter_group: nil,
        letter_order: nil,
        colour: nil,
        chart_sql_function_name: "pathology_chart_series_product_ca_phos",
        chart_colour: "orange",
        chart_logarithmic: false,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }

      Pathology::ObservationDescription.upsert_all(descriptions, unique_by: :code)
    end
  end
end
