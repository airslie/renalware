module Renalware
  module Admin
    class ConfigController < BaseController
      def show
        authorize %i(renalware admin config), :show?
        render :show, locals: { settings: displayable_settings }
      end

      private

      def displayable_settings
        (Renalware.config.methods - Object.methods)
          .flatten
          .reject { |name| name.to_s.include?("=") }
          .reject { |name| name == :config }
          .sort
      end
    end
  end
end
