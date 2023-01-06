class RemoveSiteFromInvestigatorships < ActiveRecord::Migration[5.2]
  def change
    remove_column :research_investigatorships, :hospital_centre_id, :integer
  end
end
