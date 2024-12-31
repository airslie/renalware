require "dropdown_button_item"

module Renalware
  module DropdownButtonHelper
    def dropdown_btn_item(**options)
      DropdownButtonItem.new(options).to_html
    end
  end
end
