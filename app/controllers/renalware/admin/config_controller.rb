module Renalware
  module Admin
    class ConfigController < BaseController
      def show
        authorize %i(renalware admin config), :show?
        render :show, locals: { settings: displayable_settings }
      end

      private

      # rubocop:disable Metrics/AbcSize
      def displayable_settings
        (Renalware.config.methods - Object.methods)
          .flatten
          .reject { |name| name.to_s.include?("=") }
          .reject { |name| name.to_s.include?("strategy") }
          .reject { |name| name.to_s.include?("key") }
          .reject { |name| name.to_s.include?("password") }
          .reject { |name| name.to_s.include?("pwd") }
          .reject { |name| name.to_s.include?("provider_enabled") }
          .reject { |name| name == :config }
          .sort
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
