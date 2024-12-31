# A ScheduleDefinition is a database-normalized way of expressing e.g. "Mon Wed Fri AM"
# A ScheduleDefinition has a days array e.g. [1,3,5] in the above example, where Monday = 1 etc,
# and a reference to a DiurnalPeriodCode e.g. "am".
# Defining schedules this way lets a hospital have a bit more control of the possible HD Schedules
# that a patient can have - for example it can be defined that on Mon Tu Wed once can dialyse
# in am, pm, or eve - and also allows us to define SQL that will find patients that dialyse on a
# particular day at a particular time (diurnal period).
# For example to find patients who, according to their HD Profile, dialyse on Wednesday (day=3)
# evening:
#   select p.id from patients p
#   inner join hd_profiles hdp on hdp.patient_id = p.id
#   inner join hd_schedule_definitions hds on hds.id = hdp.schedule_definition_id
#   inner join hd_diurnal_period_codes hdc on hdc.id = hds.diurnal_period_id
#   where hdc.code = 'am' and hds.days @> ARRAY[3]::integer[]
#
module Renalware
  module HD
    class ScheduleDefinition < ApplicationRecord
      ABBREV_DAY_NAMES = %w(Mon Tue Wed Thu Fri Sat Sun).freeze
      validates :days, presence: true
      validates :diurnal_period_id, presence: true
      belongs_to :diurnal_period, class_name: "DiurnalPeriodCode"
      scope :ordered, -> { order(days: :asc) }

      # Render the schedule definition to a human friendly format e.g. "Mon, Wed, Fri AM"
      # to display for example in dropdown lists when choosing a patient's preferred or actual
      # schedule.
      # Note that we store days of the week as integers starting at 1 (Monday).
      # ABBREV_DAY_NAMES is a 0-based array, so we have to subtract 1 from our days of the week
      # when mapping to a day name string.
      def to_s
        day_names = days.map { |day_number| ABBREV_DAY_NAMES[day_number - 1] }.join(" ")
        "#{day_names} #{diurnal_period.code.upcase}".strip
      end

      # Find all schedules that have a day falling on the required day.
      # For example if day_of_week is 1 (Monday) find any schedules where the Postgres days[] array
      # contains a 1 - e.g. a Mon Wed Fri AM schedule (where days = [1,3,5])
      scope :for_day_of_week, ->(day_of_week) { where("days @> ?", "{#{day_of_week}}") }

      def days_per_week
        days&.length
      end
    end
  end
end
