module Renalware
  module Dashboard
    class DashboardsController < BaseController
      skip_after_action :verify_authorized

      def show
        render :show, locals: {
          dashboard: DashboardPresenter.new(current_user)
        }
      end
    end
  end
end
