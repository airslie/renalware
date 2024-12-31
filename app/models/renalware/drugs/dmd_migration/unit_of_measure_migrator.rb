module Renalware
  module Drugs
    module DMDMigration
      # Call me to migrate from string column to foreign key to UnitOfMeasure table
      class UnitOfMeasureMigrator
        MAPPINGS = {
          ampoule: "ampoule",
          capsule: "capsule",
          drop: "drop",
          gram: "gram",
          international_unit: "iu",
          microgram: "microgram",
          milligram: "mg",
          millilitre: "ml",
          millimole: "mmol",
          nanogram: "nanogram",
          patch: "patch",
          puff: "dose",
          sachet: "sachet",
          tab: "tablet",
          tablespoon: "ml",
          tablet: "tablet",
          teaspoon: "ml",
          unit: "unit"
        }.freeze

        def call
          units_of_measure_ids_by_name = Drugs::UnitOfMeasure.pluck(:name, :id).to_h

          MAPPINGS.each do |from, to|
            units_of_measure_id = units_of_measure_ids_by_name[to]

            Medications::Prescription.where(unit_of_measure_id: nil)
              .where(dose_unit: from)
              .update_all(unit_of_measure_id: units_of_measure_id)
          end
        end
      end
    end
  end
end
