require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Pathology Measurement Units" do
    file_path = File.join(File.dirname(__FILE__), "measurement_units.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Pathology::MeasurementUnit.find_or_create_by!(name: row["name"]) do |mu|
        mu.description = row["description"]
      end
    end

    #
    # Assign equivalent UKRDC measurement unit where known otherwise set to Other
    #
    ukrdc_measurement_units = UKRDC::MeasurementUnit.all.index_by(&:name)
    ukrdc_measurement_units.each do |ukdc_name, ukrdc_uom|
      Pathology::MeasurementUnit
        .where(name: ukdc_name)
        .update!(ukrdc_measurement_unit: ukrdc_uom)
    end
  end
end
