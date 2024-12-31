module Renalware
  module HD
    module Sessions
      class AuditablePatientsInPeriodQuery
        def initialize(period:)
          @period = period
        end

        def call
          patients_with_sessions_in_this_period
        end

        private

        attr_reader :period

        def patients_with_sessions_in_this_period
          Patient
            .joins(:hd_sessions)
            .extending(SessionScopes)
            .with_finished_sessions
            .with_sessions_falling_within(period.to_range)
            .group("patients.id")
        end
      end
    end
  end
end
