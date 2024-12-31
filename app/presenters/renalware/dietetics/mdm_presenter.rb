module Renalware
  module Dietetics
    class MDMPresenter < Renalware::MDMPresenter
      def pathology_code_group_name
        :dietetics_mdm
      end

      def audits
        @audits ||= HD::PatientStatistics.for_patient(patient).limit(6).ordered
      end
    end
  end
end
