module Renalware
  module HD
    class PatientGroupDirectionsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def index
        authorize hd_patient

        pagy, pgds = pagy(
          SessionPatientGroupDirectionsQuery.new(patient: hd_patient).call
        )

        render :index, locals: { patient: hd_patient, pgds:, pagy: }
      end
    end
  end
end
