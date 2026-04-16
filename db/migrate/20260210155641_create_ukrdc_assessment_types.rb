class CreateUKRDCAssessmentTypes < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :ukrdc_assessment_types do |t|
        t.string :code, null: false
        t.string :description
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      safety_assured do
        execute <<~SQL
          INSERT INTO renalware.ukrdc_assessment_types (id, code, description) VALUES
            (1, 'TPLTassess','Suitability for renal transplant'),
            (2, 'RRTassess','Shared future RRT choice'),
            (3, 'PPDassess','Preferred place of dying') on conflict do nothing;
        SQL
      end
    end
  end
end
