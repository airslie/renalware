class CreatePeritonitisEpisodeDescriptions < ActiveRecord::Migration[4.2]
  def change
    rename_table :pd_episode_types, :pd_peritonitis_episode_type_descriptions

    create_table :pd_peritonitis_episode_types do |t|
      t.integer :peritonitis_episode_id, null: false
      t.integer :peritonitis_episode_type_description_id, null: false
    end

    add_foreign_key :pd_peritonitis_episode_types,
                    :pd_peritonitis_episodes,
                    column: :peritonitis_episode_id

    add_foreign_key :pd_peritonitis_episode_types,
                    :pd_peritonitis_episode_type_descriptions,
                    column: :peritonitis_episode_type_description_id

    add_index :pd_peritonitis_episode_types,
              [:peritonitis_episode_id, :peritonitis_episode_type_description_id],
              name: :pd_peritonitis_episode_types_unique_id,
              unique: true
  end
end
