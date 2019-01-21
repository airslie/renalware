class AddTypeToResearchParticipations < ActiveRecord::Migration[5.2]
  def change
    add_column :research_studies, :type, :string, index: true
    add_column :research_participations, :type, :string, index: true
    add_column :research_investigatorships, :type, :string, index: true
  end
end
