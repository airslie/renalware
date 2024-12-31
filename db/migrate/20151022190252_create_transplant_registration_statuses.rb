class CreateTransplantRegistrationStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :transplant_registration_statuses do |t|
      t.belongs_to :registration, index: true
      t.belongs_to :description, index: true
      t.date :started_on, null: false
      t.date :terminated_on
      t.integer :created_by_id, null: false
      t.integer :updated_by_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :transplant_registration_statuses,
                    :transplant_registrations, column: :registration_id
    add_foreign_key :transplant_registration_statuses,
                    :transplant_registration_status_descriptions, column: :description_id
  end
end
