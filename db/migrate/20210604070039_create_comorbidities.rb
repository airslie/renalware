class CreateComorbidities < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table(
        :problem_comorbidity_descriptions,
        comment: "The supported list of cormbidities that can be recorded for a patient"
      ) do |t|
        t.text :name, null: false
        t.integer :position, null: false, default: 0, index: true, comment: "Display order"
        t.string :snomed_code, comment: "Used in UKRDC exports"
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      create_enum :tristate_type, %w(unknown no yes)

      create_table(
        :problem_comorbidities,
        comment: "A single comobidity problem for a patient. " \
                 "A patient can only have one per description"
      ) do |t|
        t.references :patient, null: false, foreign_key: true, index: true
        t.references(
          :description,
          null: false,
          foreign_key: { to_table: :problem_comorbidity_descriptions }
        )
        t.enum :recognised, enum_type: :tristate_type, null: false, default: :unknown
        # t.boolean :recognised, null: true, comment: "true = yes, false = no, null = unknown"
        t.date :recognised_at, null: true, comment: "Note often only year is known"
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.timestamps null: false
      end

      add_index(
        :problem_comorbidities,
        [:patient_id, :description_id],
        unique: true,
        comment: "Only 1 unique description allowed per patient"
      )
    end
  end
end
