module Renalware
  module HD
    module Sessions
      class PreviousSessionDatesComponent < ApplicationComponent
        attr_reader :patient

        def initialize(patient:)
          @patient = patient
          super
        end

        def previous_sessions
          @previous_sessions ||= Session.where(patient: patient)
            .limit(3).order(started_at: :desc)
        end

        def not_recommended_values(current_session)
          previous_sessions
            .reject { |s| s.started_at&.to_date == current_session.started_at&.to_date }
            .map { |s| I18n.l(s.started_at.to_date) }
        end

        def render?
          previous_sessions.any?
        end
      end
    end
  end
end
