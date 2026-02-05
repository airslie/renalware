module Renalware
  module Help
    module Tours
      class PagesController < BaseController
        skip_before_action :authenticate_user!
        skip_before_action :track_ahoy_visit

        def show
          skip_authorization
          page = Tours::Page.for_route(page_route)

          if page.nil?
            render json: {}
          else
            render locals: { page: page }
          end
        end

        private

        def page_route = params[:id]
      end
    end
  end
end
