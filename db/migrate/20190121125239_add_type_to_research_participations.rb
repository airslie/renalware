class AddTypeToResearchParticipations < ActiveRecord::Migration[5.2]
  def change
    add_column :research_participations, :type, :string, index: true
  end
end
