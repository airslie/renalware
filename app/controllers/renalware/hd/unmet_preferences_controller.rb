# frozen_string_literal: true

module Renalware
  module HD
    class UnmetPreferencesController < BaseController
      include PresenterHelper

      def index
        query = PatientsWithUnmetPreferencesQuery.new(query_params)
        patients = query.call.page(params[:page])
        authorize(patients)
        render locals: {
          query: query.search,
          patients: present(patients, UnmetPreferencesPresenter)
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
