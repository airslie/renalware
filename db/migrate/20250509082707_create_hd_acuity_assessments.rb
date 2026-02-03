class CreateHDAcuityAssessments < ActiveRecord::Migration[7.0]
  def down
    drop_table :hd_acuity_assessments
  end

  def up
    within_renalware_schema do
      create_table :hd_acuity_assessments do |t|
        t.references :patient, null: false, foreign_key: { to_table: :patients }
        t.references :created_by, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, null: false, foreign_key: { to_table: :users }

        t.decimal :ratio, precision: 10, scale: 2, null: false
        t.timestamps null: false
      end

      safety_assured do
        execute <<~SQL.squish
          ALTER TABLE hd_acuity_assessments
          ADD CONSTRAINT check_ratio_valid_values
          CHECK (ratio IN (0.25, 0.33, 0.5, 1.0));
        SQL
      end
    end
  end
end
