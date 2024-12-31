class AddRequiredObservationDescriptionIdToPathologyRequestDescriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_request_descriptions, :required_observation_description_id, :integer
    add_foreign_key :pathology_request_descriptions,
                    :pathology_observation_descriptions, column: :required_observation_description_id
  end
end
