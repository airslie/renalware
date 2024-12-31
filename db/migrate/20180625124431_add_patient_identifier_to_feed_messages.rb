class AddPatientIdentifierToFeedMessages < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :feed_messages, :patient_identifier, :string, index: true
    end
  end
end
