module Renalware
  module Accesses
    def self.table_name_prefix = "access_"
    def self.cast_patient(patient) = patient.becomes(Accesses::Patient)
  end
end
