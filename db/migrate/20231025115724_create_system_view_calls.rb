class CreateSystemViewCalls < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :system_view_calls do |t|
        t.references :view_metadata, null: false, foreign_key: { to_table: :system_view_metadata }
        t.references :user, null: false, foreign_key: true
        t.datetime :called_at, null: false
      end
      add_index(
        :system_view_calls,
        %i(view_metadata_id user_id called_at),
        name: :idx_system_view_calls_all
      )
      add_column :system_view_metadata, :calls_count, :integer, default: 0
      add_column :system_view_metadata, :last_called_at, :datetime
    end
  end
end
