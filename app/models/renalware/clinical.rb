module Renalware
  module Clinical
    def self.table_name_prefix = "clinical_"
    def self.cast_patient(patient) = patient.becomes(Clinical::Patient)
  end
end
