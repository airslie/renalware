# frozen_string_literal: true

module Renalware
  class Letters::SectionList < Shared::Base
    def initialize(section_data, **attrs)
      @section_data = section_data

      super(**attrs)
    end

    def view_template(&)
      @section_data.each do |row|
        DescriptionList(class!: "flex") do
          row.each do |item|
            DescriptionListItem(item[:label], item[:value])
          end
        end
      end
    end
  end
end
