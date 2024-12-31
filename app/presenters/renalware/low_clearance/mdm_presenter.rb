module Renalware
  module LowClearance
    class MDMPresenter < Renalware::MDMPresenter
      def pathology_code_group_name
        :low_clearance_mdm
      end

      def low_clearance
        @low_clearance ||= begin
          LowClearance.cast_patient(patient).profile&.document ||
            Renalware::LowClearance::ProfileDocument.new
        end
      end
    end
  end
end
