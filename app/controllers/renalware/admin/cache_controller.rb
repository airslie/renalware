# frozen_string_literal: true

module Renalware
  module Admin
    class CacheController < BaseController
      def show
        authorize [:renalware, :admin, :cache], :show?
      end

      def destroy
        authorize [:renalware, :admin, :cache], :destroy?
        Rails.cache.clear
        redirect_to admin_cache_path, notice: "Cache successfully cleared"
      end
    end
  end
end
