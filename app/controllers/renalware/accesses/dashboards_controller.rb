module Renalware
  module Accesses
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        current_profile = Profile.current_for_patient(@patient)
        @current_profile = ProfilePresenter.new(current_profile)
        @profiles = Profile.for_patient(@patient).ordered - [@current_profile]
      end
    end
  end
end
