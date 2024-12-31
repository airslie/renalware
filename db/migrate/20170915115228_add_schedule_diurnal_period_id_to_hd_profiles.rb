class AddScheduleDiurnalPeriodIdToHDProfiles < ActiveRecord::Migration[5.1]
  def change
    # ActiveRecord::Base.clear_all_connections!
    conn = connection

    # Enable the intarray extension which is required if we want to index the days[] array
    # - see below
    conn.execute(
      "CREATE EXTENSION IF NOT EXISTS btree_gist;
       CREATE EXTENSION IF NOT EXISTS intarray;"
    )

    create_table :hd_schedule_definitions do |t|
      t.integer :days, null: false, array: true, default: []
      t.integer :diurnal_period_id, null: false, index: true
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_foreign_key :hd_schedule_definitions, :hd_diurnal_period_codes, column: :diurnal_period_id
    add_index :hd_schedule_definitions, :days, using: "gin"

    reversible do |direction|
      direction.up do
        # Create an index to make the days of week array eg [1 ,3, 5] unique within the scope
        # of a diurnal period. So for the AM period, Mon Wed Fri ([1,3,5]) can only appear once.
        conn.execute(
          "ALTER TABLE hd_schedule_definitions ADD constraint " \
          "days_array_unique_scoped_to_period EXCLUDE " \
          "USING gist(diurnal_period_id WITH =, days WITH = );"
        )
      end
      direction.down do
        conn.execute(
          "ALTER TABLE hd_schedule_definitions DROP CONSTRAINT days_array_unique_scoped_to_period;"
        )
      end
    end

    remove_column :hd_profiles, :schedule, :string
    add_column :hd_profiles, :schedule_definition_id, :integer, null: true
    add_foreign_key :hd_profiles, :hd_schedule_definitions, column: :schedule_definition_id
    add_index :hd_profiles, :schedule_definition_id

    remove_column :hd_preference_sets, :schedule, :string
    add_column :hd_preference_sets, :schedule_definition_id, :integer, null: true
    add_foreign_key :hd_preference_sets, :hd_schedule_definitions, column: :schedule_definition_id
    add_index :hd_preference_sets, :schedule_definition_id
  end
end
