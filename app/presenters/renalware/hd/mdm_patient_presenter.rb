module Renalware
  module HD
    # Presenter formatting a single patient for use behind any MDM Patients listing.
    class MDMPatientPresenter < SimpleDelegator
      def initialize(patient)
        super(HD::PatientPresenter.new(patient))
      end
    end
  end
end
