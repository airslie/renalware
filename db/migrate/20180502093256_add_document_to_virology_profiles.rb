class AddDocumentToVirologyProfiles < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :virology_profiles,
                 :document,
                 :jsonb,
                 default: {},
                 null: false

      add_reference :virology_profiles,
                    :updated_by,
                    foreign_key:
                    { to_table: :users },
                    index: true,
                    null: true

      add_reference :virology_profiles,
                    :created_by,
                    foreign_key:
                    { to_table: :users },
                    index: true,
                    null: true

      add_column :virology_profiles, :updated_at, :datetime
      add_column :virology_profiles, :created_at, :datetime

      add_index :virology_profiles, :document, using: :gin
    end
  end
end
