class AddSdsIdToClinicConsultants < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :clinic_consultants,
                   :sds_user_id,
                   :string,
                   comment: "Spine Directory Service User ID"
        add_index :clinic_consultants, :sds_user_id, unique: true
      end
    end
  end
end
