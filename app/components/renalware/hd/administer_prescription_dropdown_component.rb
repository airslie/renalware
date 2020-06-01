# frozen_string_literal: true

module Renalware
  module HD
    class AdministerPrescriptionDropdownComponent < ApplicationComponent
      include DropdownButtonHelper
      include PresenterHelper
      pattr_initialize [:patient!]

      def prescriptions_to_give_on_hd
        @prescriptions_to_give_on_hd ||= begin
          prescriptions = patient.prescriptions.includes([:drug]).to_be_administered_on_hd
          present(prescriptions, Medications::PrescriptionPresenter)
        end
      end
    end
  end
end
