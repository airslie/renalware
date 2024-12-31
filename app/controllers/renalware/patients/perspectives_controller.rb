module Renalware
  module Patients
    class PerspectivesController < BaseController
      include Renalware::Concerns::PatientVisibility

      def show
        authorize patient

        render locals: {
          patient: patient,
          perspective: perspective,
          charts: charts
        }
      end

      private

      def charts
        Pathology::Charts::Chart
          .where(scope: "perspectives/#{perspective}")
          .order(:display_group, :display_order)
      end

      def perspective
        params[:id].to_s
      end
    end
  end
end
