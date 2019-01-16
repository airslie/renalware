class AddDeletedAtToResearchMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :research_investigatorships, :deleted_at, :datetime
    add_index :research_investigatorships, :deleted_at
  end
end
