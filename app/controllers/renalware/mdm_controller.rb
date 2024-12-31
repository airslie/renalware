module Renalware
  class MDMController < BaseController
    protected

    def render_show(mdm_presenter:)
      render :show, locals: {
        mdm: mdm_presenter
      }
    end
  end
end
