class AddTerminatedOnSetByUserToPrescriptionTerminations < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_column(
          :medication_prescription_terminations,
          :terminated_on_set_by_user,
          :boolean,
          null: false,
          default: false,
          comment: "If true, the system will not attempt to set to prescribed_on + 6 months if " \
                   "prescriptions administer_on_hd=true"
        )
      end
    end
  end
end
