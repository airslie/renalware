module Renalware
  #
  # Renders flash messages either as toasts with stimulus (the app default) or as inline html
  # e.g. on login page
  #
  class FlashMessagesComponent < ApplicationComponent
    include IconHelper

    rattr_initialize [:flash_messages, toast: true]
    alias toast? toast

    def render? = flash_messages&.any?

    def css_class_for_flash(flash_key)
      case flash_key.to_sym
      when :error
        "bg-red-50 text-red-700 shadow-lg"
      else
        " bg-green-50 text-green-700 shadow-lg"
      end
    end

    def icon_for_flash(flash_key)
      case flash_key&.to_sym
      when :notice then inline_icon("check-circle", size: :md, class: "text-green-500")
      when :error then inline_icon("exclamation-circle-fill", size: :md, class: "text-red-400")
      end
    end
  end
end
