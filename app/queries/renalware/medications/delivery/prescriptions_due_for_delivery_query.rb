module Renalware
  module Medications
    module Delivery
      # Find current home delivery prescriptions with a next_delivery_date falling
      # within the specified range.
      class PrescriptionsDueForDeliveryQuery
        attr_reader :drug_type_code, :from, :to, :query, :modality_description_id

        def initialize(
          drug_type_code: nil,
          from: nil,
          to: nil,
          modality_description_id: nil,
          query: {}
        )
          @from = (from || 4.weeks.ago).beginning_of_day
          @to = (to || 2.weeks.since).end_of_day
          @drug_type_code = drug_type_code
          @query = query
          @modality_description_id = modality_description_id
        end

        def call
          query = search.result
            .current
            .includes(:patient)
            .eager_load(drug: [:drug_type_classifications, :drug_types])
            .joins("inner join patient_current_modalities pcm on pcm.patient_id = patients.id")
            .where(provider: :home_delivery)
            .where(next_delivery_date: (from..to))
            .order(next_delivery_date: :asc)

          if drug_type_code.present?
            query = query.where("lower(drug_types.code) = ?", drug_type_code)
          end

          if modality_description_id.present?
            query = query.where("pcm.modality_description_id = ?", modality_description_id)
          end
          query
        end

        def search
          @search ||= Medications::Prescription.ransack(query)
        end
      end
    end
  end
end
