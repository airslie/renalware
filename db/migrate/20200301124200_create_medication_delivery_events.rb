class CreateMedicationDeliveryEvents < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :medication_delivery_events do |t|
        t.references(
          :homecare_form,
          foreign_key: { to_table: :drug_homecare_forms },
          index: true,
          null: false
        )
        t.references(
          :drug_type,
          foreign_key: { to_table: :drug_types },
          index: true,
          null: false
        )
        t.references(:patient, index: true, null: false)
        t.string :reference_number, null: true
        t.integer :prescription_duration
        t.boolean :printed, default: false, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      # Create a sequence to generate home_delivery etc purchase order numbers.
      # These aren't guaranteed to be contiguous because of the way we use them.
      reversible do |direction|
        direction.up do
          connection.execute(<<~SQL.squish)
            CREATE SEQUENCE renalware.medication_delivery_purchase_order_number_seq
            AS integer
            START WITH 100
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;
          SQL
        end
        direction.down do
          connection.execute(
            "drop sequence if exists renalware.medication_delivery_purchase_order_number_seq;"
          )
        end
      end
    end
  end
end
