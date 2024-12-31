module Renalware
  module Transplants
    class DonorDashboardPresenter
      attr_reader_initialize :patient

      def donor_stages
        @donor_stages ||= DonorStage.for_patient(patient).ordered
      end

      def donor_workup
        @donor_workup ||= DonorWorkup.for_patient(patient).first_or_initialize
      end

      def donations
        @donations ||= Donation.for_patient(patient).reversed
      end

      def donor_operations
        @donor_operations ||= DonorOperation.for_patient(patient).reversed
      end

      def investigations
        @investigations ||= begin
          events = Events::Investigation
            .for_patient(patient)
            .transplant_donors
            .ordered
          CollectionPresenter.new(events, Events::EventPresenter)
        end
      end
    end
  end
end
