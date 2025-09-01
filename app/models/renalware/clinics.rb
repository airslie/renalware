module Renalware
  module Clinics
    def self.table_name_prefix = "clinic_"

    def self.cast_patient(patient)
      patient.is_a?(Clinics::Patient) ? patient : patient.becomes(Clinics::Patient)
    end

    module Ingestion
      def self.table_name_prefix = "clinic_ingestion_"
    end
  end
end
