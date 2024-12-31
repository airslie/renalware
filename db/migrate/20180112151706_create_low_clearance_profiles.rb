class CreateLowClearanceProfiles < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :low_clearance_profiles do |t|
        t.references :patient, foreign_key: true, index: { unique: true }, null: false
        t.jsonb :document
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.timestamps null: false
      end
      add_index :low_clearance_profiles, :document, using: :gin

      sql_for_modality_type = lambda { |mod_desc_type|
        <<-SQL.squish
          UPDATE modality_descriptions SET type = #{connection.quote(mod_desc_type)}
          WHERE name = 'Low Clearance' or name = 'Advanced Kidney Care';
        SQL
      }

      reversible do |direction|
        direction.up do
          connection.execute(
            sql_for_modality_type.call("Renalware::LowClearance::ModalityDescription")
          )
          # Move the low_clearance section of renal_profiles.document into
          # low_clearance_profiles.document
          connection.execute(
            <<-SQL.squish
              INSERT INTO low_clearance_profiles (patient_id, document, updated_at,
              created_at, updated_by_id, created_by_id)
              SELECT patient_id, rp.document -> 'low_clearance', updated_at, created_at,
              (SELECT id FROM users ORDER BY id ASC LIMIT 1),
              (SELECT id FROM users ORDER BY id ASC LIMIT 1)
              FROM renal_profiles rp;
              -- clear out the moved low_clearance section.
              UPDATE renal_profiles SET document = document - 'low_clearance';
            SQL
          )
        end
        direction.down do
          connection.execute(
            sql_for_modality_type.call("Renalware::Renal::LowClearance::ModalityDescription")
          )
          raise "If you really want to roll-back this migration you need to implement the " \
                "insertion into renal_profiles.document -> 'low_clearance' of the " \
                "low_clearance_profiles.document jsonb"
        end
      end
    end
  end
end
