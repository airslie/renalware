module Renalware
  module HD
    module Sessions
      class AuditablePatientSessionsInPeriodQuery
        def initialize(patient:, period:)
          @patient = patient
          @period = period
        end

        def call
          patient_sessions_in_period
        end

        private

        attr_reader :patient, :period

        def patient_sessions_in_period
          patient
            .hd_sessions
            .extending(SessionScopes)
            .finished
            .falling_within(period.to_range)
        end
      end
    end
  end
end
