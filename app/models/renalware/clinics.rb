module Renalware
  module Clinics
    def self.table_name_prefix = "clinic_"

    def self.cast_patient(patient)
      patient.is_a?(Clinics::Patient) ? patient : patient.becomes(Clinics::Patient)
    end
  end
end
