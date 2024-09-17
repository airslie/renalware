# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class HelpController < BaseController
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/admin" }

      def show
        authorize Transmission, :show?
      end
    end
  end
end
