class ClinicConsultantIndexes < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        remove_index :clinic_consultants, :sds_user_id
        add_index :clinic_consultants,
                  :sds_user_id,
                  unique: true,
                  where: "deleted_at IS NULL"
      end
    end
  end
end
