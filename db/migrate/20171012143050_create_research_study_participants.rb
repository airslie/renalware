class CreateResearchStudyParticipants < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :research_study_participants do |t|
        t.references :participant,
                     null: false,
                     foreign_key: { to_table: :patients },
                     index: true
        t.references :study,
                     null: false,
                     foreign_key: { to_table: :research_studies },
                     index: true
        t.date :joined_on, null: false
        t.date :left_on
        t.datetime :deleted_at
        t.references :updated_by, foreign_key: { to_table: :users }, index: true
        t.references :created_by, foreign_key: { to_table: :users }, index: true
        t.timestamps null: false
      end

      # This create a postgres partial index
      # A participant can only be enrolled once in a study  must be unique in for any unit
      # Ignoring any times there were deleted (for example because they were added in error and so
      # removed, but subsequently added again)
      add_index :research_study_participants,
                [:participant_id, :study_id],
                name: :unique_study_participants,
                unique: true,
                where: "deleted_at IS NULL"
    end
  end
end
