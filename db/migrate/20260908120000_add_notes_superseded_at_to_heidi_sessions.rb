class AddNotesSupersededAtToHeidiSessions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :heidi_sessions, :notes_superseded_at, :datetime
    end
  end
end
