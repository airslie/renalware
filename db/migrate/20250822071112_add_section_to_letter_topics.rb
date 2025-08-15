class AddSectionToLetterTopics < ActiveRecord::Migration[7.0]
  def up
    create_enum :letter_sections, %w(hd pd transplants akcc)
    add_column :letter_descriptions, :section_identifier, :enum, enum_type: :letter_sections, default: nil

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

  def down
    remove_column :letter_descriptions, :section_identifier
    drop_enum :letter_sections

    safety_assured do
      execute <<-SQL.squish
        UPDATE letter_section_snapshots SET section_identifier = 'hd_section'
        WHERE section_identifier = 'hd'
      SQL
    end
  end
end
