module Renalware
  module Pathology
    module Requests
      class SampleDescription
        include ActionView::Helpers::TextHelper

        def initialize(sample_type, sample_number_bottles)
          @sample_type = sample_type
          @sample_number_bottles = sample_number_bottles
        end

        def to_s
          if @sample_type.present? && @sample_number_bottles.present?
            " (#{@sample_type}, #{sample_number_bottles_string})"
          elsif @sample_type.present?
            " (#{@sample_type})"
          elsif @sample_number_bottles.present?
            " (#{sample_number_bottles_string})"
          else
            ""
          end
        end

        private

        def sample_number_bottles_string
          pluralize(@sample_number_bottles, "bottle", plural: "bottles")
        end
      end
    end
  end
end
