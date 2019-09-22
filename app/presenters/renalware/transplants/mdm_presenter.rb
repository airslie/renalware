# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class MDMPresenter < Renalware::MDMPresenter
      def recipient_operations
        RecipientOperation.for_patient(patient).reversed
      end

      def cmvdna_pathology
        @cmvdna_pathology ||= pathology_for_codes("CMVD")
      end
    end
  end
end
