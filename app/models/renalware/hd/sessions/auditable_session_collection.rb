#
# Decorates an array of session objects, adding methods that provide e.g. a mean measured value
# across all HD sessions for a patient. See also AuditableSession.
#
# Example usage:
#
#  recent_sessions = RecentPatientSessions.call # => [Session::DNA, Session::Closed, ...]
#  auditable_sessions = AuditableSessionCollection.new(recent_sessions)
#  auditable_sessions.pre_mean_systolic_blood_pressure => 121
#
# Note that resolution is to integer not float i.e. pre_mean_systolic_blood_pressure will
# return 100 if the only measurement is 100.11.

module Renalware
  module HD
    module Sessions
      class AuditableSessionCollection < SimpleDelegator
        AUDITABLE_ATTRIBUTES = %i(
          number_of_missed_sessions
          dialysis_minutes_shortfall
          dialysis_minutes_shortfall_percentage
          pre_mean_systolic_blood_pressure
          pre_mean_diastolic_blood_pressure
          post_mean_systolic_blood_pressure
          post_mean_diastolic_blood_pressure
          lowest_systolic_blood_pressure
          highest_systolic_blood_pressure
          mean_fluid_removal
          mean_weight_loss
          mean_weight_loss_as_percentage_of_body_weight
          mean_machine_ktv
          mean_blood_flow
          mean_litres_processed
          mean_ufr
          number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct
        ).freeze

        def initialize(sessions)
          @sessions = Array(sessions).map do |session|
            Renalware::HD::Sessions::AuditableSession.new(session)
          end
          super(@sessions)
        end

        def to_h
          AUDITABLE_ATTRIBUTES.each_with_object({}) do |sym, hash|
            hash[sym] = public_send(sym)
            hash
          end
        end

        def number_of_missed_sessions
          sessions.count(&:dna?)
        end

        def pre_mean_systolic_blood_pressure
          mean_blood_pressure(:observations_before, :systolic)
        end

        def pre_mean_diastolic_blood_pressure
          mean_blood_pressure(:observations_before, :diastolic)
        end

        def post_mean_systolic_blood_pressure
          mean_blood_pressure(:observations_after, :systolic)
        end

        def post_mean_diastolic_blood_pressure
          mean_blood_pressure(:observations_after, :diastolic)
        end

        def lowest_systolic_blood_pressure
          all_systolic_blood_pressure_measurements.min_by(&:systolic)
        end

        def highest_systolic_blood_pressure
          all_systolic_blood_pressure_measurements.max_by(&:systolic)
        end

        def dialysis_minutes_shortfall
          sessions.sum(&:dialysis_minutes_shortfall)
        end

        def dialysis_minutes_shortfall_percentage
          selector = ->(session) { session.dialysis_minutes_shortfall_percentage }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call.round(2)
        end

        def number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct
          sessions.count(&:dialysis_minutes_shortfall_gt_5_pct?)
        end

        def mean_ufr
          selector = ->(session) { session.ufr }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_fluid_removal
          selector = ->(session) { session.document.dialysis.fluid_removed }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_weight_loss
          selector = ->(session) { session.weight_loss }
          MeanValueStrategy.new(
            sessions: closed_sessions.reject { |sess| sess.weight_loss.nil? },
            selector: selector
          ).call
        end

        def mean_weight_loss_as_percentage_of_body_weight
          selector = ->(session) { session.weight_loss_as_percentage_of_body_weight }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_machine_ktv
          selector = ->(session) { session.document.dialysis.machine_ktv }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_blood_flow
          selector = ->(session) { session.document.dialysis.blood_flow }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_litres_processed
          selector = ->(session) { session.document.dialysis.litres_processed }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        class MeanValueStrategy
          attr_reader :sessions, :selector

          def initialize(sessions:, selector:)
            @sessions = sessions
            @selector = selector
          end

          def call
            values.blank? ? 0 : mean
          end

          # Note here we ignore values that cannot be coerced into a number
          # Any values like "## TEST CANCELLED" etc are thus excluded from the calculation
          def values
            @values ||= begin
              sessions
                .filter_map { |session| selector.call(session) }
                .select { |val| number?(val) }
            end
          end

          def total
            @total ||= values.inject(0.0) { |sum, value| sum + value.to_f }
          end

          def mean
            (total.to_f / values.count.to_f).round(2)
          end

          def number?(val)
            Float(val)
            true
          rescue ArgumentError, TypeError
            false
          end
        end

        private

        attr_accessor :sessions

        def closed_sessions
          @closed_sessions ||= sessions.select(&:closed?)
        end

        def all_blood_pressure_measurements
          sessions.map(&:blood_pressure_measurements).flatten
        end

        # rubocop:disable Style/RescueModifier
        def all_systolic_blood_pressure_measurements
          all_blood_pressure_measurements
            .select(&:systolic)
            .select { |bp| true if Float(bp.systolic) rescue false }
        end
        # rubocop:enable Style/RescueModifier

        # Helper to build a dynamic selector to grab the observation (pre/post) and blood pressure
        # measurement (sys/dias) and mean them.
        # Example usage:
        #   mean_blood_pressure(:observations_after, :diastolic)
        def mean_blood_pressure(observation, measurement)
          selector = ->(session) {
            session
              .document
              .public_send(observation)
              .blood_pressure
              .public_send(measurement)
          }
          MeanValueStrategy.new(sessions: sessions, selector: selector).call
        end
      end
    end
  end
end
