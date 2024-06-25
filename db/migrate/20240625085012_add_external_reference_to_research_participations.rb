class AddExternalReferenceToResearchParticipations < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :research_participations, :external_reference, :string
        add_index :research_participations,
                  %i(study_id external_reference),
                  unique: true,
                  where: "deleted_at is null and coalesce(external_reference, '') != ''"
      end
    end
  end
end
