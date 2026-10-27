module Renalware
  class Admin::DashboardsController < BaseController
    def show
      authorize User, :index?
      @placements = System::Dashboard.global("admin")&.visible_placements_for(current_user) || []
    end
  end
end
