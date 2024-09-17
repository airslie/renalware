class AddUuidToUsers < ActiveRecord::Migration[6.0]
  def up
    within_renalware_schema do
      add_column :users, :uuid, :uuid
      change_column_default :users, :uuid, 'uuid_generate_v4()'
    end
  end

  def down
    within_renalware_schema do
      drop_column :users, :uuid
    end
  end
end
