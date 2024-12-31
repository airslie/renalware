module Renalware
  module Clinical
    class Patient < Renalware::Patient
      has_many :allergies, dependent: :restrict_with_exception
      has_many :dry_weights, dependent: :restrict_with_exception
      has_one :igan_risk, dependent: :destroy

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      # These statuses match NHS standards for the display of recorded allergy status.
      # Note that
      # - if no_known_allergies then patient.allergies must be empty
      # - if known_allergies then patient.allergies must be not be empty
      # - unavailable is not currently used
      enumerize :allergy_status,
                in: %i(unrecorded
                       known_allergies
                       no_known_allergies
                       unavailable),
                default: "unrecorded"

      def latest_dry_weight
        @latest_dry_weight ||= dry_weights.latest
      end
    end
  end
end
