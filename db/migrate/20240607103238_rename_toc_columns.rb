class RenameTocColumns < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        rename_column :patient_practices, :toc_mesh_mailbox_id, :mesh_mailbox_id
        rename_column :patient_practices, :toc_mesh_mailbox_description, :mesh_mailbox_description
      end
    end
  end
end
