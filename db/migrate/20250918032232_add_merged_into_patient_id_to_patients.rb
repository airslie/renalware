class AddMergedIntoPatientIdToPatients < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_reference(
          :patients,
          :merged_into_patient,
          foreign_key: { to_table: :patients },
          index: true,
          comment: <<~COMMENT
            After an HL7 A34 or A40 merge, points to the major patient
            that this minor patient was merged into
          COMMENT
        )
      end
    end
  end
end
