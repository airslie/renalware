class AddDeletedAtToResearchMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :research_memberships, :deleted_at, :datetime
    add_index :research_memberships, :deleted_at
  end
end
