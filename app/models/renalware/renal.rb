require_dependency "renalware"

module Renalware
  module Renal
    def self.table_name_prefix
      "renal_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Renal::Patient)
    end

    module LowClearance
      MDM_FILTERS = %w(urea hgb1 hgb2 on_worryboard tx_candidates).freeze
    end
  end
end
