class CreateDrugHomecareSuppliers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :duration, %w(minute hour day week month year)

      create_table(
        :drug_suppliers,
        comment: "A list of suppliers who deliver drugs eg for homecare"
      ) do |t|
        t.string(
          :name,
          null: false,
          comment: "The providers display name e.g. 'Fresenius'"
        )
        t.timestamps
      end

      # Has many through
      create_table(
        :drug_homecare_forms,
        comment: "X-ref table that says which drug_type is supplied by which (homecare) supplier " \
                 "and the data required (see form_name and form_version) to programmatically " \
                 "select and create the right PDF Homecare Supply form for them (using the " \
                 "renalware-forms gem) so this can be printed out and signed."
      ) do |t|
        t.references :drug_type, null: false
        t.references :supplier, null: false, foreign_key: { to_table: :drug_suppliers }

        t.string(
          :form_name,
          null: false,
          comment: "The lower-case programmatic name used for this provider, eg 'fresenius'"
        )
        t.string(
          :form_version,
          null: false,
          comment: "A number e.g. '1' that specified what version of the homecare supply form" \
                   "should be created"
        )
        t.string(
          :prescription_durations,
          null: false,
          array: true,
          default: [],
          comment: "An array of options where each integer is a number of units - these will be " \
                   "displayed as dropdown options presented to the user, and checkboxes " \
                   "on the homecare delivery form PDF. E.g [3,6] will " \
                   "be displayed as options '3 months' and '6 months' (see also " \
                   "prescription_duration_unit)"
        )
        t.integer(
          :prescription_duration_default,
          null: true,
          comment: "The default option to pre-select when displaying prescription_duration_options"
        )
        t.enum(
          :prescription_duration_unit,
          null: false,
          enum_type: :duration,
          comment: "E.g. 'week' or 'month'"
        )
        t.timestamps null: false
      end

      add_index(
        :drug_homecare_forms,
        [:drug_type_id, :supplier_id],
        unique: true,
        comment: "A supplier can only have one form active for any drug type"
      )
    end
  end
end
