module Renalware
  module DashboardsHelper
    def composed_dashboard_title(user_name)
      capture do
        concat tag.span(I18n.t("renalware.dashboard.dashboards.title"))
        concat tag.span(user_name, class: "dashboard-owner")
      end
    end
  end
end
