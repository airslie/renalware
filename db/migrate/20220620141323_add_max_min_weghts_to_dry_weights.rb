class AddMaxMinWeghtsToDryWeights < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column(
        :clinical_dry_weights,
        :minimum_weight,
        :float,
        null: true,
        comment: "Set by the clinicial, if the patient's weight drops below this value then " \
                 "the clinican may decide change drugs etc"
      )
      add_column(
        :clinical_dry_weights,
        :maximum_weight,
        :float,
        null: true,
        comment: "Set by the clinicial, if the patient's weight rises above this value then " \
                 "the clinican may decide change drugs etc"
      )
    end
  end
end
