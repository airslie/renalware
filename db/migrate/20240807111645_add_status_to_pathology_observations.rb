class AddStatusToPathologyObservations < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      comment = <<~COMMENT
        OBX.11 - Observation Result Status
        Definition:
        C Record coming over is a correction and thus replaces a final result
        D Deletes the OBX record
        F Final results; Can only be changed with a corrected result.
        I Specimen in lab; results pending
        N Not asked
        O Order detail description only (no result)
        P Preliminary results
        R Results entered -- not verified
        S Partial results. Deprecated. Retained only for backward compatibility as of V2.6.
        U Results status change to final without retransmitting results already sent as preliminary
        W Post original as wrong, e.g., transmitted for wrong patient
        X Results cannot be obtained for this observation
      COMMENT

      # See e.g. https://hl7-definition.caristix.com/v2/HL7v2.8/Tables/0085
      create_enum :enum_hl7_observation_result_status_codes, %w(C D F I N O P R S U W X)

      # Note:
      # - adding a comment to the column as cannot yet add a comment to an enum in a migration
      # - an index will be added manually or in separate migration due to the performance hit
      add_column :pathology_observations,
                 :result_status,
                 :enum_hl7_observation_result_status_codes,
                 null: true,
                 comment: comment
    end
  end
end
