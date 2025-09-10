# frozen_string_literal: true

module Renalware
  class Letters::SectionList < Shared::Base
    def initialize(section_data, **attrs)
      @section_data = section_data

      super(**attrs)
    end

    def view_template(&)
      @section_data.each do |row|
        # Ensure we don't have any CSS here as we'll be rendering this as a PDF
        # and the CSS will be inlined and using CSS2 which is what wkhtmltopdf uses.
        # We disable the HTML comment added by Shared::Base as it makes the diffs
        # harder to debug.
        DescriptionList(class!: nil, debug: false) do
          row.each do |item|
            DescriptionListItem(item[:label], item[:value], debug: false)
          end
        end
      end
    end
  end
end
