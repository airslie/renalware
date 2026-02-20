module Renalware
  module Letters
    module Transports
      module Mesh
        class ActivityComponent < ApplicationComponent
          include IconHelper

          pattr_initialize [:current_user!]
          STATUS_KEYS = %i(pending success failure).freeze

          COLOURS = {
            success: "bg-green-200",
            failure: "bg-red-200",
            pending: "bg-yellow-50"
          }.freeze

          def stats
            {
              "Today" => stats_for(created_at: Time.zone.now.beginning_of_day..),
              "Last 7 days" => stats_for(created_at: 7.days.ago..),
              "Last month" => stats_for(created_at: 1.month.ago..),
              "All time" => stats_for
            }
          end

          def colour_for(state)
            COLOURS[state&.to_sym]
          end

          private

          def stats_for(created_at: nil)
            scope = Transmission.where(status: STATUS_KEYS)
            scope = scope.where(created_at:) if created_at.present?

            counts = scope.group(:status).count

            STATUS_KEYS.index_with { |status| counts.fetch(status.to_s, 0) }
          end
        end
      end
    end
  end
end
