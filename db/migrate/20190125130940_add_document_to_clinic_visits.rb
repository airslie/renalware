class AddDocumentToClinicVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :clinic_visits, :document, :jsonb, default: {}, null: false
    add_index :clinic_visits, :document, using: :gin

    # Support STI
    add_column :clinic_visits, :type, :string
    add_index :clinic_visits, :type
  end
end
