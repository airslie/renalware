module Renalware
  module HD
    def self.table_name_prefix = "hd_"
    def self.cast_patient(patient) = patient.becomes(HD::Patient)

    module SessionForms
      def self.table_name_prefix = "hd_session_form_"
    end
  end
end
