class AddManagerToResearchInvestigatorships < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :research_investigatorships,
        :manager,
        :boolean,
        null: false,
        default: false
      )
    end
  end
end
