# frozen_string_literal: true

module Renalware
  #
  # Renders flash messages either as toasts with stimulus (the app default) or as inline html
  # e.g. on login page
  #
  class FlashMessagesComponent < ApplicationComponent
    rattr_initialize [:flash_messages, toast: true]
    STYLES = { notice: "success", error: "alert", warning: "warning" }.freeze
    alias :toast? :toast

    def render?
      flash_messages&.any?
    end

    def css_class_for_flash(flash_key)
      case flash_key.to_sym
      when :error
        "bg-red-50 text-red-700 shadow-lg"
      else
        "bg-blue-50 text-blue-700 shadow-lg"
      end
    end

    def flash_style(name)
      STYLES[name.to_sym]
    end
  end
end
