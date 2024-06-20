class CreateTransplantInductionAgents < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      within_renalware_schema do
        create_table :transplant_induction_agents do |t|
          t.text :name, null: false
          t.integer :position, null: false, default: 0
          t.text :drug_name
          t.text :snomed_code
          t.text :atc_code
          t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
          t.index "lower((name)::text)", unique: true, name: "index_transplant_induction_agents_on_name"
        end

        safety_assured do
          add_reference(
            :transplant_recipient_operations,
            :induction_agent,
            foreign_key: { to_table: "transplant_induction_agents" },
            index: true
          )
        end
      end
    end
  end
end
