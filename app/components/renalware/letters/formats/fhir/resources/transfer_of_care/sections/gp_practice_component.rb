# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class GPPracticeComponent < SectionComponent
      delegate :primary_care_physician, :practice, to: :patient
      delegate :name, to: :primary_care_physician, prefix: true, allow_nil: true
      delegate :name, :address, to: :practice, prefix: true, allow_nil: true

      def address_presenter
        AddressPresenter.new(practice.address)
      end
    end
  end
end
