module Renalware
  module Feeds
    # This model captures the point when a request is made (eg programmatically when a patient is
    # added due to an AKI alert or Clinic Appointment HL7 message) to replay historical pathology
    # for a patient and we reference the id of this model in each MessageReplay (along with the
    # feed_message_id). Here we also ensure there is no other ongoing replay for a patient.
    # Scenario:
    #  - HL7 msg A arrives - its a clinic appt and the patient is not in RW so it creates them
    #  - it spawns a job to find and import hist path in case we have any for them.
    #  - That job kicks off and starts importing pathology. Lets say it takes 1 minute.
    #  - Before its finished, another HL7 message arrives for the same patient. However as the
    #    patient is already in RW they are not created and no hist path job is spawned.
    #  - so there is limited scope for a race condition and multiple replay requests for the same
    #    patient, but we do log and quit if there is previous unfinished replay.
    #    On the whole, as long as each MessageReplay is idempotent then there is no issue.
    class ReplayRequest < ApplicationRecord
      validates :started_at, presence: true
      validates :patient, presence: true
      has_many :message_replays, dependent: :destroy
      belongs_to :patient, class_name: "Renalware::Patient"

      def self.policy_class = BasePolicy

      # Class method creates and yields a new replay_request which spans an entire replay operation
      def self.start_logging(patient, reason, **criteria)
        log_ongoing_replay(patient) && return if another_replay_ongoing?(patient)

        replay_request = create!(
          started_at: Time.zone.now,
          patient: patient,
          reason: reason,
          criteria: criteria
        )
        yield replay_request
        replay_request
      ensure
        replay_request&.update!(finished_at: Time.zone.now)
      end

      # Return true if we found another unfinished replay - we want to avoid re-entry
      def self.another_replay_ongoing?(patient)
        exists?(patient_id: patient.id, finished_at: nil)
      end

      def self.log_ongoing_replay(patient)
        create!(
          patient: patient,
          started_at: Time.zone.now,
          finished_at: Time.zone.now,
          error_message: "An unfinished replay found for patient #{patient.id} so cannot " \
                         "continue. Please add a finished_at datetime to that row if it has " \
                         "stalled/failed for any reason and retry"
        )
      end

      # Instance method logs the results of an individual replay of a feed_message
      def log(feed_message, urn)
        self.total_messages += 1
        msg_replay = message_replays.create!(message: feed_message, urn: urn)
        yield
        feed_message.update!(processed: true)
        msg_replay.success = true
      rescue StandardError => e
        self.failed_messages += 1
        msg_replay.error_message = e.full_message
        msg_replay.success = false
      ensure
        save!
        msg_replay.save!
      end
    end
  end
end
