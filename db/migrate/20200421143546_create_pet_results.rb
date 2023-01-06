class CreatePETResults < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :pd_pet_type, %w(full fast)

      create_table :pd_pet_results do |t|
        t.references :patient, null: false, foreign_key: true

        # The first set are inputs when seeing the patient
        t.date :performed_on, null: false
        t.enum :test_type, enum_type: :pd_pet_type, null: false
        t.integer :volume_in
        t.integer :volume_out
        t.references(
          :dextrose_concentration,
          foreign_key: { to_table: :pd_pet_dextrose_concentrations },
          index: true,
          null: true
        )
        t.integer :infusion_time
        t.integer :drain_time
        t.integer :overnight_volume_in
        t.integer :overnight_volume_out
        t.references(
          :overnight_dextrose_concentration,
          foreign_key: { to_table: :pd_pet_dextrose_concentrations },
          index: true,
          null: true
        )
        t.integer :overnight_dwell_time

        # This set is manually or automatically added pathology after the fact
        # Refers to dialysate samples
        [0, 2, 4, 6].each do |hr|
          t.float :"sample_#{hr}hr_time"
          t.float :"sample_#{hr}hr_urea"
          t.float :"sample_#{hr}hr_creatinine"
          t.float :"sample_#{hr}hr_glc"
          t.float :"sample_#{hr}hr_sodium"
          t.float :"sample_#{hr}hr_protein"
        end

        # Blood results back from the lab
        t.float :serum_time
        t.float :serum_urea
        t.float :serum_creatinine
        t.float :plasma_glc
        t.float :serum_ab
        t.float :serum_na

        # This set is for calculated fields
        t.integer :net_uf
        t.float :d_pcr
        t.boolean :complete, default: false, null: false, indeex: true

        t.datetime :deleted_at, index: true
        t.references :created_by, index: true, null: false
        t.references :updated_by, index: true, null: false
        t.timestamps null: false
      end

      add_foreign_key :pd_pet_results, :users, column: :created_by_id
      add_foreign_key :pd_pet_results, :users, column: :updated_by_id
    end
  end
end
