require "collection_presenter"

module Renalware
  module Medications
    class SummaryPart < Renalware::SummaryPart
      delegate :prescriptions, to: :patient

      def current_prescriptions
        @current_prescriptions ||= begin
          prescripts = prescriptions
            .includes(drug: [:drug_types, :drug_type_classifications])
            .includes(:medication_route, :trade_family, :unit_of_measure)
            .current
            .ordered
          CollectionPresenter.new(prescripts, Medications::PrescriptionPresenter)
        end
      end

      def to_partial_path
        "renalware/medications/summary_part"
      end

      # The cache key here must be such that a change to any prescription or its associated
      # drug (including a reclassification of drug_type e.g. changing from ESA to immunosuppressant
      # or a change in the drug name) will invalidate the cache for this patient's prescriptions.
      # So we build a composite cache_key based on prescriptions and their drugs.
      # Note we rely on an a couple of things here:
      # - an after_remove callback in Drug -> Classification to set updated_at on the drug; removing
      #   classifications uses a delete not a destroy so otherwise would not touch the parent drug.
      # - adding a drug classification to a drug (e.g. making a drug ESA) touches the drug and this
      #   generates a new cache_key here
      # - note that although adding `belongs_to :prescription, touch: true` to Drug would solve
      #   our cache validation here, that would mean knowing the Drugs module knowing about the
      #   Prescriptions module, when currently only the reverse is acceptable (i.e.
      #   Prescriptions -> Drugs)
      def cache_key
        # Based on AR::Relation.cache_key, this key incorporates the following, scoped to the
        # current patient:
        # - patient cachekey eg renalware/patients/166-20180306184938146827
        # - max(prescriptions.updated)
        # - count(prescriptions)
        # - max(drug.updated_at) in drugs across all prescriptions
        # - count(drugs) across all prescriptions (same as prescriptions.count so not really
        #   required, but comes for free with AR::Relation.cache_key)
        [
          patient.cache_key_with_version,
          prescriptions.cache_key_with_version,
          Drugs::Drug.where(id: prescriptions.pluck(:drug_id)).cache_key_with_version
        ].join("$")
      end
    end
  end
end
