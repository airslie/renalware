module Renalware
  module Transplants
    # Presenter formatting a single patient for use behind any MDM Patients listing.
    class MDMPatientPresenter < Renalware::MDMPatientPresenter
      def last_operation_on
        Transplants::RecipientOperation
          .for_patient(__getobj__)
          .order(performed_on: :desc)
          .limit(1)
          .pick(:performed_on)
      end
    end
  end
end
