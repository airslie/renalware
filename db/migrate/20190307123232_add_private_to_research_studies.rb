class AddPrivateToResearchStudies < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :research_studies, :private, :boolean, default: false, null: false
      add_index :research_studies, :private
    end
  end
end
