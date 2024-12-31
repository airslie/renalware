module Renalware
  module System
    # Experimental ActionView component
    class AdminMenuComponent < ApplicationComponent
      include Renalware::UsersHelper

      rattr_initialize [:current_user!]

      def admin_menu_item(*)
        return unless
          current_user_is_admin? ||
          current_user_is_super_admin? ||
          current_user_is_developer?

        menu_item(*)
      end

      def super_admin_menu_item(*)
        return unless current_user_is_super_admin? || current_user_is_developer?

        menu_item(*)
      end

      def developer_menu_item(*)
        return unless current_user_is_developer?

        menu_item(*)
      end

      def menu_item(title, path, active_when_controller_matches, enabled = true)
        klasses = %w(link)
        klasses << "active" if current_controller_matches(active_when_controller_matches)
        tag.li class: klasses.join(" ") do
          if enabled
            link_to(title, path)
          else
            tag.span title
          end
        end
      end

      def current_controller_matches(regex)
        regex.match(params[:controller]).present?
      end

      def formatted_nhs_number(patient)
        ::Renalware::PatientPresenter.new(patient).nhs_number
      end
    end
  end
end
