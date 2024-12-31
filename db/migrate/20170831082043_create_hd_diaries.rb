class CreateHDDiaries < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_diaries do |t|
      # Ensure the base Diary class is abstract, ie you can only save STI sub-classes like
      # MasterDiary, which have an STI type.
      t.string :type, index: true, null: false
      t.references :hospital_unit, null: false, foreign_key: true, index: true
      t.integer :master_diary_id, null: true, foreign_key: true, index: true
      t.integer :week_number, null: true, index: true
      t.integer :year, null: true, index: true
      t.boolean :master, null: false, default: false
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    add_foreign_key :hd_diaries, :users, column: :created_by_id
    add_foreign_key :hd_diaries, :users, column: :updated_by_id
    add_foreign_key :hd_diaries, :hd_diaries, column: :master_diary_id

    # If this is
    add_index :hd_diaries,
              [:hospital_unit_id, :week_number, :year],
              unique: true,
              where: "master = false"
    add_index :hd_diaries,
              :hospital_unit_id,
              unique: true,
              where: "master = true",
              name: "master_index_hd_diaries_on_hospital_unit_id"

    # Add CHECK constraint to ensure week_number and year are in valid ranges
    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          ALTER TABLE hd_diaries ADD CONSTRAINT week_number_in_valid_range CHECK (week_number >= 1 AND week_number <= 53);
          ALTER TABLE hd_diaries ADD CONSTRAINT year_in_valid_range CHECK (year >= 2017 AND year <= 2050);
        SQL
      end
      direction.down do
        execute <<-SQL.squish
          ALTER TABLE hd_diaries DROP CONSTRAINT week_number_in_valid_range;
          ALTER TABLE hd_diaries DROP CONSTRAINT year_in_valid_range;
        SQL
      end
    end

    # Would like to add an index here for WeeklyDiary implementation, but as this table is shared
    # with MasterDiary, we can't do this unless we use partial indexes?
    # add_index :hd_diaries, [:hospital_unit_id, :week_number, :year], unique: true

    # Would like to add an index here for MasterDiary implementation (allow only one per hospital)
    # but as this table is shared with WeeklyDiary, we can't do this  unless we use partial indexes?
    # add_index :hd_diaries, [:hospital_unit_id, :week_number, :year], unique: true
  end
end
