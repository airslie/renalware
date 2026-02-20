module Renalware
  module HD
    module Sessions
      class LatestPatientSessionsQuery
        def initialize(patient:)
          @patient = patient
        end

        def call(starting_on: 4.weeks.ago, ending_on: Time.zone.today, max_sessions: 12)
          Session
            .extending(Scopes)
            .for_patient(patient)
            .not_ongoing
            .ordered
            .within_period(starting_on, ending_on)
            .limit(max_sessions)
        end

        private

        attr_reader :patient

        module Scopes
          def for_patient(patient)
            where(patient: patient)
          end

          def within_period(starting_on, ending_on)
            where(started_at: starting_on.beginning_of_day..ending_on.end_of_day)
          end

          def not_ongoing
            where(type: [Session::Closed.sti_name, Session::DNA.sti_name])
          end
        end
      end
    end
  end
end
