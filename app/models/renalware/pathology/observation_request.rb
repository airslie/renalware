module Renalware
  module Pathology
    class ObservationRequest < ApplicationRecord
      include RansackAll

      has_many :observations,
               foreign_key: :request_id,
               inverse_of: :request,
               dependent: :destroy
      belongs_to :description, class_name: "RequestDescription", inverse_of: :requests
      belongs_to :patient, class_name: "Patient", touch: true

      accepts_nested_attributes_for :observations

      validates :patient, presence: true
      validates :requestor_name, presence: true
      validates :requested_at, presence: true

      scope :ordered, -> { order(requested_at: :desc) }

      # Excludes duplicate rows; there may be an original OBR and one or more updates (with more
      # complete results) and we only want the last received one got any requestor_order_number
      # (actually for any requestor_order_number + requested_at + description_id) combination
      # because requestor_order_number is sometimes blank
      def self.distinct_for_patient_id(patient_id)
        select(
          Arel.sql(
            "DISTINCT ON (patient_id, requestor_order_number, requested_at, description_id) id"
          )
        )
          .where(patient_id: patient_id)
          .order(
            patient_id: :asc,
            requestor_order_number: :asc,
            requested_at: :asc,
            description_id: :asc,
            created_at: :desc
          )
      end

      def requested_on
        requested_at.to_date
      end
    end
  end
end
