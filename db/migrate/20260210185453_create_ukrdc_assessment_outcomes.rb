class CreateUKRDCAssessmentOutcomes < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :ukrdc_assessment_outcomes, id: false do |t|
        t.integer :code, null: false, primary_key: true
        t.string :description
        t.references(
          :assessment_type,
          null: false,
          foreign_key: { to_table: :ukrdc_assessment_types }
        )
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
