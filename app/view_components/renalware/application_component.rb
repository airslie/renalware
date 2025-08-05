module Renalware
  class ApplicationComponent < ViewComponent::Base
    include Pundit::Authorization

    include Renalware::Engine.routes.url_helpers

    delegate :current_user, to: :helpers

    # Not sure why include Renalware::Engine.routes.url_helpers does not make the
    # engine urls visible in the views (seems to resolve always to /assets?..)
    # so we expose routes here so inside a component html file we can use
    # e.g. renalware.bookmarks_path
    def renalware
      Renalware::Engine.routes.url_helpers
    end

    def hospitals
      Renalware::Hospitals::Engine.routes.url_helpers
    end
  end
end
