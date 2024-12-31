module Renalware
  module Admin
    class CacheController < BaseController
      def show
        authorize %i(renalware admin cache), :show?
      end

      def destroy
        authorize %i(renalware admin cache), :destroy?
        Rails.cache.clear
        redirect_to admin_cache_path, notice: "Cache successfully cleared"
      end
    end
  end
end
