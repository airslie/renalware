# Testing UI ideas
module Renalware
  class ProtouisController < BaseController
    layout false
    skip_before_action :authenticate_user!
    skip_after_action :verify_authorized
    skip_before_action :track_ahoy_visit

    def index
      render :index
    end
  end
end
