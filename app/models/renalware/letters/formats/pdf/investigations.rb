# frozen_string_literal: true

module Renalware
  module Letters
    module Formats
      module Pdf
        # Renders pathology results grouped by date in the format eg:
        #   12-Jan-2090: HGB 123, WBC n/a; 23-Jan-2090: PHOS 45, POT 23
        class Investigations
          include Prawn::View
          # :results is in the format
          # { date_string: { code_1: value_1, code_2: value_2 }, .. }
          pattr_initialize :document, [:results!]

          def build # rubocop:disable Metrics/MethodLength
            pad(10) do
              pad_bottom(5) { text "Recent Investigations", style: :bold }
              buffer = []
              Array(results).each do |results_hash|
                next if results_hash.empty?

                results_hash.each do |date, hash|
                  buffer << { text: "#{date}: ", styles: [:italic] }
                  hash.each.with_index do |(obx, value), idx|
                    buffer << { text: "#{obx} " }
                    buffer << { text: value }
                    buffer << { text: ", " } unless (idx + 1) == hash.length
                  end
                  buffer << { text: "; " }
                end
              end
              formatted_text buffer
            end
          end
        end
      end
    end
  end
end
