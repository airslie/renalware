class AddExpirationDaysToPathologyRequestDescriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :pathology_request_descriptions, :expiration_days, :integer,
               null: false, default: 0
  end
end
