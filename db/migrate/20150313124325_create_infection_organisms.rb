class CreateInfectionOrganisms < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_infection_organisms do |t|
      t.references :organism_code, null: false
      t.text :sensitivity
      t.references :infectable, polymorphic: true
      t.timestamps null: false
    end
    add_index(:pd_infection_organisms, [:organism_code_id, :infectable_id, :infectable_type],
              name: "idx_infection_organisms", unique: true)
    add_index(:pd_infection_organisms, [:infectable_id, :infectable_type], name: "idx_infection_organisms_type")

    add_foreign_key :pd_infection_organisms, :pd_organism_codes, column: :organism_code_id
  end
end
