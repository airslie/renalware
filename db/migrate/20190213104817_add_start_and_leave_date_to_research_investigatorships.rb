class AddStartAndLeaveDateToResearchInvestigatorships < ActiveRecord::Migration[5.2]
  def change
    add_column :research_investigatorships, :started_on, :date
    add_column :research_investigatorships, :left_on, :date
  end
end
