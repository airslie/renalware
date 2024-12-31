module Renalware
  module HD
    module Sessions
      class CloseStaleOpenSessions
        include Callable

        attr_reader :closed_session_ids, :unclosed_session_ids, :performed_before

        class CloseableSessionQuery
          pattr_initialize [:performed_before!]

          def each
            Session::Open
              .where(started_at: ..performed_before)
              .where.not(signed_off_by: nil)
              .find_each do |session|
              # Note the bang in becomes! is crucial in copying the session attributes
              # and setting the sti column appropriately
              yield CloseableSession.new(session.becomes!(Session::Closed))
            end
          end
        end

        class CloseableSession < SimpleDelegator
          include Renalware::Engine.routes.url_helpers

          def close
            self.profile = patient.hd_profile
            self.signed_off_at = Time.zone.now
            self.stopped_at ||= started_at + 3.hours # assumed default if no stopped_at present
            self.dry_weight = Renalware::Clinical::DryWeight.for_patient(patient).first
            valid? && document.valid? && save_by(Renalware::SystemUser.find)
          end

          def all_errors
            [
              errors.full_messages,
              document.dialysis.errors.full_messages,
              document.observations_before.errors.full_messages,
              document.observations_after.errors.full_messages,
              document.hdf.errors.full_messages,
              document.info.errors.full_messages
            ].flatten.uniq.compact
          end

          def url
            edit_patient_hd_session_path(patient, self)
          end
        end

        def initialize(performed_before: 3.days.ago)
          @performed_before = performed_before
          @closed_session_ids = []
          @unclosed_session_ids = []
        end

        def call
          log_start
          results = OpenStruct.new(closed_ids: [], unclosed_ids: [])

          CloseableSessionQuery.new(performed_before: performed_before).each do |session|
            if session.close
              results.closed_ids << session.id
              log("[Session #{session.id}] - closed")
            else
              results.unclosed_ids << session.id
              log("[Session #{session.id}] - unclosed: #{session.all_errors.join(', ')}")
              log("[Session #{session.id}] - #{session.url}")
            end
          end
          log_results(results)
          results
        end

        private

        def log_start
          log("Trying to close stale open sessions performed before #{performed_before}")
        end

        def log_results(results)
          log("#{results.closed_ids.count} sessions closed")
          log("#{results.unclosed_ids.count} sessions could not be closed")
        end

        def log(msg = "")
          Rails.logger.info(msg)
        end
      end
    end
  end
end
