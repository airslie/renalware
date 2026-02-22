module Renalware
  module HD
    module Sessions
      # A form object used to display and capture the HD Session start and stop dates and times.
      # From the UI perspective there is:
      # - start_date (aka performed_on) which is the date dialysis started
      # - start_time eg 11:00 (stored as a Time for convenience but displayed as a string)
      # - end_time eg 13:00
      # - overnight_dialysis - a boolean which when checked by the user allows them to choose an
      #   end_date before the start time
      # These map into the database as
      # - started_at datetime
      # - stopped_at datetime (the date might be day after started_at if overnight_dialysis = true)
      #
      # We assign a duration_form instance to the HD::Session when displaying the session form UI.
      # If displaying a new session, the dates and times will be empty.
      # If editing an existing session, the duration_form_for(session) factory method will
      # set the attributes according to the started_at and stopped_at attributes on the session.
      class DurationForm
        include ActiveModel::Model
        include ActiveModel::Attributes
        include ActiveModel::Validations

        attribute :start_date, :date
        attribute :start_time, :time
        attribute :end_time, :time
        attribute :overnight_dialysis, :boolean
        attribute :require_all_fields, :boolean # will be true when signing-off the session

        validates :start_date, presence: true, timeliness: { type: :date, allow_blank: true }
        validates :start_time,
                  timeliness: {
                    type: :time,
                    if: -> { require_all_fields == true }
                  },
                  presence: { if: -> { require_all_fields == true } }

        # If overnight_dialysis is true then we allow the end time to be before the
        # start time, as it refers to the next day
        validates(
          :end_time,
          timeliness: {
            type: :time,
            allow_blank: true,
            after: ->(form) { form.overnight_dialysis ? "00:00" : form.start_time },
            after_message: "must be after 'Start time' unless 'Overnight dialysis' is checked"
          },
          presence: { if: ->(form) { form.require_all_fields == true } }
        )

        # Factory method that builds a duration form object so we can use it behind
        # the html session form when editing the session.
        def self.duration_form_for(session)
          form = new
          form.start_date = session.started_at

          # If started_at was at midnight exactly we are going to assume that session was saved with
          # just a date and no time chosen, so rather than say the time is "00:00" we should make it
          # null
          if session.started_at && session.started_at.seconds_since_midnight > 0
            form.start_time = session.started_at
          end

          form.end_time = session.stopped_at
          form.overnight_dialysis = false
          if session.stopped_at.present?
            form.overnight_dialysis =
              session.stopped_at.seconds_since_midnight < session.started_at.seconds_since_midnight
          end
          form
        end

        def started_at
          return unless valid?

          start = start_date_in_time_zone

          if start_time.present?
            start += start_time.seconds_since_midnight
          end
          start
        end

        # If overnight_dialysis is true then add 1 day to the start_date
        def stopped_at
          return unless valid?
          return unless start_date.present? && end_time.present?

          date = overnight_dialysis ? start_date_in_time_zone + 1.day : start_date_in_time_zone
          date.to_time + end_time.seconds_since_midnight
        end

        private

        def start_date_in_time_zone
          @start_date_in_time_zone ||= start_date.in_time_zone
        end
      end
    end
  end
end
