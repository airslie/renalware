class AddAnuricToHDProfiles < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      # This is intentionally tri-state: nil means Unknown, true/false means explicitly set.
      # rubocop:disable Rails/ThreeStateBooleanColumn
      add_column :hd_profiles, :anuric, :boolean, null: true
      # rubocop:enable Rails/ThreeStateBooleanColumn
    end
  end
end
