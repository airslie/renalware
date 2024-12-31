class CreateBagTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_bag_types do |t|
      t.string :manufacturer, null: false
      t.string :description,  null: false
      t.decimal :glucose_grams_per_litre, precision: 4, scale: 1, null: false
      t.boolean :amino_acid
      t.boolean :icodextrin
      t.boolean :low_glucose_degradation
      t.boolean :low_sodium
      t.integer :sodium_mmole_l
      t.integer :lactate_mmole_l
      t.integer :bicarbonate_mmole_l
      t.decimal :calcium_mmole_l, precision: 3, scale: 2
      t.decimal :magnesium_mmole_l, precision: 3, scale: 2
      t.datetime :deleted_at
      t.timestamps null: false
    end
    add_index :pd_bag_types, :deleted_at
  end
end
