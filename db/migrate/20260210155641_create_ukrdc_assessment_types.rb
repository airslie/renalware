class CreateUKRDCAssessmentTypes < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :ukrdc_assessment_types do |t|
        t.string :code, null: false
        t.string :description
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      execute <<~SQL
        INSERT INTO renalware.ukrdc_assessment_types (code, description) VALUES
          ('TPLTassess','Suitability for renal transplant'),
          ('RRTassess','Shared future RRT choice'),
          ('PPDassess','Preferred place of dying') on conflict do nothing;
      SQL
    end
  end
end
