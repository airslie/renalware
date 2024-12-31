module Renalware
  module Patients
    class ClinicalSummariesController < BaseController
      skip_after_action :verify_authorized
      include Renalware::Concerns::PatientVisibility

      def show
        clinical_summary = Renal::ClinicalSummaryPresenter.new(patient)
        render :show, locals: { clinical_summary: clinical_summary, patient: patient }
      end
    end
  end
end
