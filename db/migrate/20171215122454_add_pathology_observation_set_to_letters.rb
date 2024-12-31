class AddPathologyObservationSetToLetters < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :letter_letters,
                 :pathology_snapshot,
                 :jsonb,
                 index: { using: :gin },
                 default: {},
                 null: false
    end
  end
end
