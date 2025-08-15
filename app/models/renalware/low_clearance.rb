module Renalware
  module LowClearance
    MDM_FILTERS = %w(urea hgb_low hgb_high on_worryboard supportive_care tx_candidates).freeze

    # Low clearance is now known as AKCC (Acute Kidney Care Clinic)
    # TODO: rename this table to match the model
    def self.table_name_prefix = "low_clearance_"
    def self.cast_patient(patient) = patient.becomes(LowClearance::Patient)
  end
end
