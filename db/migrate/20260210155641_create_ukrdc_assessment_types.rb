class CreateUKRDCAssessmentTypes < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :ukrdc_assessment_types do |t|
        t.string :code, null: false
        t.string :description
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end
    end
  end
end
