class CreateHDDiarySlots < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_diary_slots do |t|
      t.integer :diary_id, null: false, index: true
      t.integer :station_id, null: false, index: true
      t.integer :day_of_week, null: false, index: true
      t.integer :diurnal_period_code_id, null: false, index: true
      t.references :patient, null: false, foreign_key: true, index: true
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    # Add CHECK constraint to ensure week and year are in valid ranges
    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          ALTER TABLE hd_diary_slots
            ADD CONSTRAINT day_of_week_in_valid_range CHECK (day_of_week >= 1 AND day_of_week <= 7);
        SQL
      end
      direction.down do
        execute <<-SQL.squish
          ALTER TABLE hd_diary_slots DROP CONSTRAINT day_of_week_in_valid_range;
        SQL
      end
    end

    add_foreign_key :hd_diary_slots, :hd_stations, column: :station_id
    add_foreign_key :hd_diary_slots, :hd_diaries, column: :diary_id
    add_foreign_key :hd_diary_slots, :users, column: :created_by_id
    add_foreign_key :hd_diary_slots, :users, column: :updated_by_id
    add_foreign_key :hd_diary_slots, :hd_diurnal_period_codes, column: :diurnal_period_code_id
  end
end
