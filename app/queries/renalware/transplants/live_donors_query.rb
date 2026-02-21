module Renalware
  module Transplants
    class LiveDonorsQuery
      DEFAULT_ORDER = %w(family_name given_name).freeze

      def initialize(params: {}, relation: Patient.all)
        @params = params
        @relation = relation
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          patients.ransack(params).tap do |search|
            search.sorts = DEFAULT_ORDER
          end
        end
      end

      private

      def patients
        relation
          .include(ModalityScopes)
          .with_current_modality_of_class(DonorModalityDescription)
      end

      attr_reader :params, :relation
    end
  end
end
