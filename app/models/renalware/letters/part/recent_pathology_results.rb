require "renalware/letters/part"

module Renalware
  module Letters
    class Part::RecentPathologyResults < DumbDelegator
      def initialize(patient, service: nil)
        @patient = patient

        service ||= default_service(patient)
        super(service.call)
      end

      private

      def default_service(patient)
        presenter = Pathology::CurrentObservationResults::Presenter.new
        Pathology::ViewCurrentObservationResults.new(patient, presenter)
      end
    end
  end
end
