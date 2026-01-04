class AddAdRoleNameToRoles < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :roles, :ad_role_name, :string
    end
  end
end
