class RenameResearchStudyParticipations < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      rename_table :research_study_participations, :research_participations
    end
  end
end
