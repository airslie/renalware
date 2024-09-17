class AddUuidToLetterArchives < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :letter_archives, :uuid, :uuid
        change_column_default :letter_archives, :uuid, from: nil, to: "uuid_generate_v4()"
        reversible do |direction|
          direction.up do
            execute(<<~SQL.squish)
              update renalware.letter_archives set uuid = uuid_generate_v4() where uuid is null
            SQL
          end
        end
        change_column_null :letter_archives, :uuid, false
        add_index :letter_archives, :uuid, unique: true
      end
    end
  end
end
