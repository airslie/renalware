class ChangeResearchParticipationExternalIdType < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      reversible do |direction|
        direction.up do
          safety_assured do
            add_column :research_participations,
                       :external_id_deprecated,
                       :integer,
                       if_not_exists: true,
                       comment: "Backup of external_id taken before changing " \
                                "its type from int to text"
            execute(<<~SQL.squish)
              update research_participations set external_id_deprecated = external_id
            SQL
            change_column :research_participations, :external_id, :text
          end
        end
        direction.down do
          safety_assured do
            change_column :research_participations,
                          :external_id,
                          "integer USING external_id::integer"
          end
        end
      end
    end
  end
end
