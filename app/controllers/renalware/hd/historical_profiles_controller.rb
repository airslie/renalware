require "collection_presenter"

module Renalware
  module HD
    class HistoricalProfilesController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      include PresenterHelper

      def index
        profiles = Profile.deleted.ordered.for_patient(hd_patient)
        authorize profiles
        render locals: {
          patient: hd_patient,
          profiles: present(profiles, ProfilePresenter)
        }
      end

      def show
        profile = Profile.deleted.for_patient(hd_patient).find(params[:id])
        authorize profile
        render locals: {
          patient: hd_patient,
          profile: ProfilePresenter.new(profile)
        }
      end
    end
  end
end
