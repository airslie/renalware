class AddSectionToLetterTopics < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      drop_enum :letter_sections, if_exists: true

      add_column :letter_descriptions, :section_identifier, :string, default: nil

      safety_assured do
        execute <<-SQL.squish
          UPDATE letter_descriptions SET section_identifier = 'hd'
          WHERE section_identifiers = ARRAY['hd_section']::character varying[]
        SQL

        execute <<-SQL.squish
          UPDATE letter_section_snapshots SET section_identifier = 'hd'
          WHERE section_identifier = 'hd_section'
        SQL
      end
    end
  end

  def down
    within_renalware_schema do
      remove_column :letter_descriptions, :section_identifier

      safety_assured do
        execute <<-SQL.squish
          UPDATE letter_section_snapshots SET section_identifier = 'hd_section'
          WHERE section_identifier = 'hd'
        SQL
      end
    end
  end
end
