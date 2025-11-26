class AddAzureUuidToUsers < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :users, :azure_uid, :string
        add_index  :users, :azure_uid, unique: true
      end
    end
  end
end
