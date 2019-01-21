class AddDocumentToResearchTables < ActiveRecord::Migration[5.2]
  def change
    add_column :research_studies, :document, :jsonb
    add_index :research_studies, :document, using: :gin
    add_column :research_participations, :document, :jsonb
    add_index :research_participations, :document, using: :gin
    add_column :research_investigatorships, :document, :jsonb
    add_index :research_investigatorships, :document, using: :gin
  end
end
