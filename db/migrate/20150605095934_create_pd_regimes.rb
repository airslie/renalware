class CreatePDRegimes < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_regimes do |t|
      t.references :patient, null: false, foreign_key: true
      t.date :start_date,    null: false
      t.date :end_date
      t.string :treatment, null: false
      t.string :type
      t.integer :glucose_ml_percent_1_36
      t.integer :glucose_ml_percent_2_27
      t.integer :glucose_ml_percent_3_86
      t.integer :amino_acid_ml
      t.integer :icodextrin_ml
      t.boolean :add_hd
      t.integer :last_fill_ml
      t.boolean :add_manual_exchange
      t.boolean :tidal_indicator
      t.integer :tidal_percentage
      t.integer :no_cycles_per_apd
      t.integer :overnight_pd_ml
      t.string :apd_machine_pac
      t.timestamps null: false
    end
  end
end
