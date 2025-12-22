class RenameClinicConsultantsSdsUserId < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        rename_column :clinic_consultants, :sds_user_id, :sds_user_id_deprecated
      end
    end
  end
end
