class CreateTransplantsRegistrationStatusDescriptions < ActiveRecord::Migration
  def change
    create_table :transplants_registration_status_descriptions do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
