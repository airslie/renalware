# frozen_string_literal: true

module Renalware
  module Pathology
    class CurrentObservationResultsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def index
        authorize pathology_patient
        observation_set = ObservationSetPresenter.new(
          pathology_patient.fetch_current_observation_set
        )
        render :index, locals: { observation_set: observation_set, patient: pathology_patient }
      end
    end
  end
end
