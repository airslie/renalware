module Renalware
  module LowClearance
    class Patient < Renalware::Patient
      has_one :profile, dependent: :destroy

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      def ever_been_on_low_clearance?
        @ever_been_on_low_clearance ||=
          modality_descriptions.exists?(type: "Renalware::LowClearance::ModalityDescription")
      end
    end
  end
end
