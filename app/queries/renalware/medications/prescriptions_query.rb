module Renalware
  module Medications
    class PrescriptionsQuery
      def initialize(relation:, search_params: nil, apply_default_search_order: true)
        @relation = relation
        @search_params = search_params || {}
        if apply_default_search_order
          @search_params.reverse_merge!(s: default_search_order)
        end
      end

      def call
        search.result
      end

      def search
        @search ||= @relation.includes([:trade_family, :unit_of_measure])
          .ransack(@search_params)
      end

      private

      def default_search_order
        Prescription.default_search_order
      end
    end
  end
end
