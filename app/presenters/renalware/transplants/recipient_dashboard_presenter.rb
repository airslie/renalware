module Renalware
  module Transplants
    class RecipientDashboardPresenter
      attr_reader_initialize :patient

      def recipient_workup
        @recipient_workup ||= RecipientWorkup.for_patient(patient).first_or_initialize
      end

      def registration
        @registration ||= WaitListRegistrationPresenter.new(
          Registration.for_patient(patient).first_or_initialize
        )
      end

      def recipient_operations
        @recipient_operations ||= RecipientOperation.for_patient(patient).reversed
      end

      def donations
        @donations ||= Donation.for_recipient(patient).reversed
      end

      def investigations
        @investigations ||= begin
          events = Events::Investigation
            .for_patient(patient)
            .transplant_recipients
            .ordered
          CollectionPresenter.new(events, Events::EventPresenter)
        end
      end
    end
  end
end
