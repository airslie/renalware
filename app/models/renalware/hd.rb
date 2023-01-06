# frozen_string_literal: true

module Renalware
  module HD
    def self.table_name_prefix = "hd_"

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::HD::Patient)
    end

    module SessionForms
      def self.table_name_prefix = "hd_session_form_"
    end
  end
end
