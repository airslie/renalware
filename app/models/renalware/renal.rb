module Renalware
  module Renal
    def self.table_name_prefix = "renal_"
    def self.cast_patient(patient) = patient.becomes(Renal::Patient)
  end
end
