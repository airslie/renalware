module Renalware
  module Clinical
    class DryWeightsPresenter
      DEFAULT_LIMIT = 10_000
      attr_reader :patient, :limit

      def initialize(patient:, dry_weights: nil, limit: nil)
        @patient = patient
        @limit = limit || DEFAULT_LIMIT
        @weights = dry_weights # optional otherwise we grab them ourselves
      end

      def dry_weights
        @dry_weights ||= begin
          CollectionPresenter.new(
            weights,
            Renalware::Clinical::DryWeightPresenter
          )
        end
      end

      private

      def weights
        @weights ||= begin
          Renalware::Clinical::DryWeight
            .for_patient(patient)
            .includes(:assessor)
            .limit(limit)
            .ordered
        end
      end
    end
  end
end
