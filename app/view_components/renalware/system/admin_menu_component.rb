module Renalware
  module System
    class AdminMenuComponent < ApplicationComponent
      include Renalware::IconHelper
      include Renalware::UsersHelper

      MenuItem = Data.define(:title, :path, :controller_pattern, :keywords, :icon, :sort_key)
      MenuSection = Data.define(:key, :title, :items)
      I18N_SCOPE = "renalware.system.admin_menu_component".freeze
      MENU_CONFIG = YAML.safe_load_file(
        File.join(__dir__, "admin_menu_component.yaml"),
        symbolize_names: true
      ).freeze

      rattr_initialize [:current_user!]

      def render? = current_user_is_admin?

      def primary_items
        @primary_items ||= build_items(
          MENU_CONFIG.fetch(:primary),
          i18n_scope: "#{I18N_SCOPE}.primary"
        )
      end

      def menu_sections
        @menu_sections ||= MENU_CONFIG.fetch(:sections).filter_map do |definition|
          key = definition.fetch(:key)
          i18n_scope = "#{I18N_SCOPE}.sections.#{key}"
          items = build_items(definition.fetch(:items), i18n_scope: "#{i18n_scope}.items")
          items.sort_by! { |item| (item.sort_key || item.title).downcase }

          title = translate_menu_label(i18n_scope, :title)
          MenuSection.new(key:, title:, items:) if items.any?
        end
      end

      def render_menu_item(menu_item, section_title: nil)
        classes = ["admin-menu__item", ("active" if active?(menu_item))].compact
        search_text = ([section_title, menu_item.title] + menu_item.keywords).compact.join(" ")

        tag.li(
          class: classes,
          data: { admin_menu_filter_target: "item", search_text: }
        ) do
          link_to(menu_item.path) { menu_item_content(menu_item) }
        end
      end

      def section_active?(section)
        section.items.any? { |menu_item| active?(menu_item) }
      end

      private

      def build_items(definitions, i18n_scope:)
        definitions.filter_map do |definition|
          build_item(definition, i18n_scope:)
        end
      end

      def build_item(definition, i18n_scope:)
        return unless visible_for?(definition.fetch(:access, :admin))
        return unless condition_met?(definition[:condition])

        MenuItem.new(
          title: translate_menu_label(i18n_scope, definition.fetch(:key)),
          path: resolve_route(definition),
          controller_pattern: Regexp.new(definition.fetch(:controller)),
          keywords: Array(definition[:keywords]),
          icon: definition[:icon],
          sort_key: definition[:sort_key]
        )
      end

      def menu_item_content(menu_item)
        return menu_item.title unless menu_item.icon

        text_with_icon_prefix(
          menu_item.title,
          menu_item.icon,
          aria_hidden: true
        )
      end

      def resolve_route(definition)
        route = definition.fetch(:route)
        scope = definition[:route_scope]
        route_proxy = scope ? public_send(scope) : helpers.main_app
        route_proxy.public_send(route)
      end

      def translate_menu_label(*key_parts)
        t(key_parts.join("."))
      end

      def visible_for?(access)
        case access.to_sym
        when :admin then current_user_is_admin?
        when :super_admin then current_user_is_super_admin?
        when :developer then current_user_is_developer?
        else raise ArgumentError, "Unknown admin menu access level: #{access}"
        end
      end

      def condition_met?(condition)
        case condition&.to_sym
        when nil then true
        when :dmd_match_enabled then policy(Renalware::Drugs::DMDMatch).index?
        when :heidi_enabled then Renalware.config.heidi_enabled
        when :non_production then !Rails.env.production?
        else raise ArgumentError, "Unknown admin menu condition: #{condition}"
        end
      end

      def active?(menu_item)
        menu_item.controller_pattern.match?(params[:controller].to_s)
      end
    end
  end
end
