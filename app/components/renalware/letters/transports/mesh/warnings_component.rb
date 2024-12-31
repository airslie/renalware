module Renalware
  module Letters
    module Transports
      module Mesh
        class WarningsComponent < ApplicationComponent
          include IconHelper

          NUMBER_TO_DISPLAY = 100
          pattr_initialize [:current_user!]

          COLOURS = {
            success: "bg-green-200",
            failure: "bg-red-200",
            pending: "bg-yellow-50"
          }.freeze

          def stats
            {
              "Today" => { pending: 10, success: 11, failure: 1 },
              "7 days" => { pending: 0, success: 101, failure: 5 },
              "All time" => { pending: 0, success: 401, failure: 7 }
            }
          end

          def errors
            query.take(NUMBER_TO_DISPLAY)
          end

          def total_errors
            query.count
          end

          def number_to_display = NUMBER_TO_DISPLAY

          def query
            Transmission
              .includes(:operations)
              .order(created_at: :desc)
              .where(status: :failure)
            # .where(operations: { itk3_response_code: "fatal-error" })
            # .where(letter_id: 42)
          end

          def colour_for(state)
            COLOURS[state&.to_sym]
          end
        end
      end
    end
  end
end
