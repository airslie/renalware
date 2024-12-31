class CreateClinicalIganRisks < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :clinical_igan_risks do |t|
        t.references(
          :patient,
          foreign_key: true,
          index: true,
          null: false
        )
        t.decimal(
          :risk,
          precision: 5, # total number of digits - needs to be 5 to allow for 100.00
          scale: 2, # 2 dp
          null: false,
          comment: "The risk of a 50% decline in estimated GFR or progression to end-stage renal " \
                   "disease 4.2 years after renal biopsy. Calculated using an external website " \
                   "and is a %value eg 40.1%"
        )

        t.text(
          :workings,
          :text,
          comment: "The calculation output or summary (a block of text) which the user can copy to " \
                   "the clipboard manually from the from the external website, and paste into " \
                   "RW to be saved here. Details the parameters they input as well as the " \
                   "calculated risk"
        )
      end
    end
  end
end
