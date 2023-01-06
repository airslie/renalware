class AddSectionIdentifiersToLetterTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :letter_descriptions, :section_identifiers, :string, array: true, default: []
  end
end
