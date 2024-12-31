module Renalware
  module Surveys
    class DashboardsController < BaseController
      def show
        authorize Survey, :index?
        render locals: {
          patient: patient,
          eq5d_responses: EQ5DPivotedResponse.where(patient: patient).ordered,
          pos_s_responses: PosSPivotedResponse.where(patient: patient).ordered
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
