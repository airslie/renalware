# frozen_string_literal: true

module Renalware
  module LowClearance
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :profile, dependent: :destroy

      def ever_been_on_low_clearance?
        @ever_been_on_low_clearance ||=
          modality_descriptions.exists?(type: "Renalware::LowClearance::ModalityDescription")
      end
    end
  end
end
