module Renalware
  module Transplants
    class MDMPresenter < Renalware::MDMPresenter
      def pathology_code_group_name
        :transplant_mdm
      end

      def recipient_operations
        RecipientOperation.for_patient(patient).reversed
      end

      def cmvdna_pathology
        @cmvdna_pathology ||= begin
          Pathology::CreateObservationsGroupedByDateTable.new(
            patient: patient,
            observation_descriptions: pathology_descriptions_for_codes("CMVD"),
            per_page: 6,
            page: 1
          ).call
        end
      end

      private

      def pathology_descriptions_for_codes(codes)
        if codes.nil?
          Pathology::RelevantObservationDescription.all
        else
          codes = Array(codes)
          descriptions = Pathology::ObservationDescription.for(Array(codes))
          warn("No OBX(es) found for codes #{codes}") if descriptions.empty?
          descriptions
        end
      end
    end
  end
end
