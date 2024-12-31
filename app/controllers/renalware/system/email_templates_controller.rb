module Renalware
  module System
    class EmailTemplatesController < BaseController
      skip_after_action :verify_authorized

      def index
        render
      end
    end
  end
end
