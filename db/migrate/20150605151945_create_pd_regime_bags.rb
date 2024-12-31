class CreatePDRegimeBags < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_regime_bags do |t|
      t.references :regime, null: false
      t.references :bag_type,   null: false
      t.integer :volume,        null: false
      t.integer :per_week
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday
      t.timestamps null: false
    end

    add_foreign_key :pd_regime_bags, :pd_regimes, column: :regime_id
    add_foreign_key :pd_regime_bags, :pd_bag_types, column: :bag_type_id
  end
end
