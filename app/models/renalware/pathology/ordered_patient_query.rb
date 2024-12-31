require "sql_indexed_case_stmt"

module Renalware
  module Pathology
    class OrderedPatientQuery
      def initialize(patient_ids)
        @patient_ids = patient_ids
      end

      def call
        Pathology::Patient
          .where(id: @patient_ids)
          .order(ids_index)
      end

      private

      def ids_index
        ::SqlIndexedCaseStmt.new("patients.id", @patient_ids).generate
      end
    end
  end
end
