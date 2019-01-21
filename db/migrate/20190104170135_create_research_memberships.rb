class CreateResearchMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :research_investigatorships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study, foreign_key: { to_table: :research_studies }, index: true, null: false
      t.references :hospital_centre, foreign_key: true, index: true, null: false

      t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
      t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      t.timestamps null: false
    end
  end
end
