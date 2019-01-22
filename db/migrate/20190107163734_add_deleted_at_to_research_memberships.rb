class AddDeletedAtToResearchMemberships < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :research_investigatorships, :deleted_at, :datetime
      add_index :research_investigatorships, :deleted_at
    end
  end
end
