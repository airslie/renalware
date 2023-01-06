# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionVersion < PaperTrail::Version
      self.table_name = :medication_prescription_versions
    end
  end
end
