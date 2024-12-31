require "collection_presenter"

module Renalware
  module Admissions
    class PatientAdmissionsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        admissions = Admission
          .where(patient_id: patient.id).page(page).per(per_page)
          .order(admitted_on: :desc)
        authorize admissions
        render locals: {
          admissions: CollectionPresenter.new(admissions, AdmissionPresenter)
        }
      end
    end
  end
end
