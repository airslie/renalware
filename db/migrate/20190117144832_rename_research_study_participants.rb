class RenameResearchStudyParticipants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      rename_table :research_study_participants, :research_study_participations
      rename_column :research_study_participations, :participant_id, :patient_id
    end
  end
end
