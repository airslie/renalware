module Renalware
  module Patients
    class AbridgementsController < BaseController
      def index
        authorize Abridgement, :index?
        render locals: {
          form: AbridgementSearchForm.new,
          results: abridgements_matching_search_criteria,
          results_matching_dob: abridgements_matching_dobs
        }
      end

      private

      def abridgements_matching_search_criteria
        return [] if search_params.blank?

        Abridgement.where(hospital_number: search_params)
      end

      def abridgements_matching_dobs
        return [] if abridgements_matching_search_criteria.empty?

        dobs = abridgements_matching_search_criteria.map(&:born_on).uniq.compact
        return [] if dobs.empty?

        Abridgement.where(born_on: dobs) - abridgements_matching_search_criteria
      end

      def search_params
        params.dig(:search, :criteria)
      end
    end
  end
end
