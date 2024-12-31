module Renalware
  module FlashHelper
    def css_class_for_flash(flash_key)
      case flash_key.to_sym
      when :error
        "bg-red-100 text-red-700"
      else
        "bg-blue-100 text-blue-700"
      end
    end
  end
end
