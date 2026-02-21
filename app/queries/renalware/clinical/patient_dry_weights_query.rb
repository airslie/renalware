module Renalware
  module Clinical
    class PatientDryWeightsQuery
      def initialize(patient:, search_params: nil)
        @patient = patient
        @search_params = search_params || {}
        @search_params.reverse_merge!(s: "assessed_on desc")
      end

      def call
        search.result
      end

      def search
        @search ||= DryWeight.where(patient: @patient).ransack(@search_params)
      end
    end
  end
end
