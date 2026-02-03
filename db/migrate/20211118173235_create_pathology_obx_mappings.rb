class CreatePathologyOBXMappings < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      comment = <<~COMMENT.squish
        In a multi-site installation, one hospital might use a different OBX code (eg HB or HBN)
        from the one Renalware expects (in this case HGB). This table enables that mapping so that
        incoming OBX results from different sites are mapped to a single observation_description.
        This table defines the expected MSH sending facility/app to match against.
      COMMENT
      create_table(:pathology_obx_mappings, comment: comment) do |t|
        t.string :code_alias, null: false, index: true, comment: "The hosp-specific code eg 'HB'"
        t.text :comment, comment: "Optional text to help understand mapping issues"
        t.references(
          :sender,
          null: false,
          foreign_key: { to_table: "pathology_senders" },
          index: true,
          comment: "A definition of the sending facility (eg RAJ01) and sending app (eg WinPath)"
        )
        t.references(
          :observation_description,
          null: false,
          foreign_key: { to_table: :pathology_observation_descriptions },
          index: true,
          comment: "The Renalware standarised OBX we are mapping to"
        )
        t.references :updated_by, foreign_key: { to_table: :users }, index: true
        t.references :created_by, foreign_key: { to_table: :users }, index: true
        t.timestamps null: false
      end

      add_index(
        :pathology_obx_mappings,
        [:code_alias, :sender_id],
        unique: true,
        name: "pathology_obx_mappings_uniqueness",
        comment: "Ensures only one mapping row per sender + code_alias."
      )
    end
  end
end
