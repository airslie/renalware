class AddIdToRolesUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :roles_users, :id, :primary_key
  end
end
