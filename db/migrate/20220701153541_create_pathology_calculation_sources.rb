class CreatePathologyCalculationSources < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :pathology_calculation_sources do |t|
        t.references(
          :calculated_observation,
          null: false,
          index: false,
          foreign_key: { to_table: :pathology_observations },
          comment: "Id of the calculated observation e.g. URR derived from pre and post UREA"
        )
        t.references(
          :source_observation,
          null: false,
          index: false,
          foreign_key: { to_table: :pathology_observations },
          comment: "Id of an observation used in the calculation e.g. a UREA observation"
        )
        t.index(
          [
            :calculated_observation_id,
            :source_observation_id
          ],
          unique: true,
          name: :pathology_calculation_sources_idx
        )
      end
    end
  end
end
