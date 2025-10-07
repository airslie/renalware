class RenameDeathLocationsRrOutcomeCode < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      safety_assured do
        rename_column :death_locations, :rr_outcome_code, :ukrdc_assessment_outcome_code
        add_foreign_key :death_locations,
                        :ukrdc_assessment_outcomes,
                        column: :ukrdc_assessment_outcome_code,
                        primary_key: :code
        remove_column :death_locations, :rr_outcome_text, :string
      end
    end
  end
end
