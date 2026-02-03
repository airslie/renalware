class AddNamedNurseToPatients < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference :patients, :named_nurse, references: :users, index: true
      add_foreign_key :patients, :users, column: :named_nurse_id

      reversible do |direction|
        direction.up do
          # Migrate the named_nurse_id column from hd_profiles to patients
          sql = <<~SQL.squish
            UPDATE renalware.patients P
            SET named_nurse_id = HP.named_nurse_id
            FROM renalware.hd_profiles HP
            WHERE
              HP.patient_id = P.id
              and P.named_nurse_id is null
              and HP.named_nurse_id is not null
              and HP.deactivated_at is null;
          SQL
          connection.execute sql
        end
        direction.down do
          # noop
        end
      end

      # Rename hd_profiles.named_nurse_id to named_nurse_id_legacy so it is not used
      change_table :hd_profiles do |t|
        t.rename :named_nurse_id, :named_nurse_id_legacy
      end
    end
  end
end
