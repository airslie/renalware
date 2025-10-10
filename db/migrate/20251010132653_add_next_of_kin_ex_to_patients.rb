class AddNextOfKinExToPatients < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        rename_column(
          :patients,
          :next_of_kin,
          :next_of_kin_notes
        )
        change_column_comment(
          :patients,
          :next_of_kin_notes,
          from: "",
          to: "Manually entered next of kin details, not from HL7"
        )
        add_column(
          :patients,
          :next_of_kin,
          :text,
          comment: "Next of kin details from HL7 NK1 segments"
        )
      end
    end
  end
end
