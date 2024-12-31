module Renalware
  module Virology
    def self.table_name_prefix = "virology_"
    def self.cast_patient(patient) = patient.becomes(Virology::Patient)
  end
end
