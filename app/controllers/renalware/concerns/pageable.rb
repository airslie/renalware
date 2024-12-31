require "active_support/concern"

module Renalware
  module Concerns::Pageable
    extend ActiveSupport::Concern

    included do
      def page
        params[:page]
      end

      def per_page
        params[:per_page] || 20
      end
    end
  end
end
