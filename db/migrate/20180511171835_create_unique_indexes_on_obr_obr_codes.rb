class CreateUniqueIndexesOnObrObrCodes < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_index :pathology_observation_descriptions, :code
      add_index :pathology_observation_descriptions, :code, unique: true
      add_index :pathology_request_descriptions, :code, unique: true
    end
  end
end
