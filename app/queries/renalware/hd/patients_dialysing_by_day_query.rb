# Find for example HD Patients who according to their HD Profile dialyse on Monday
# at a particular unit
# Example usage in that instance (1 == Monday):
#   PatientsDialysingByDayQuery.new(unit_id, 1).call
#
module Renalware
  module HD
    class PatientsDialysingByDayQuery
      attr_reader :hospital_unit_id, :day_of_week

      def initialize(hospital_unit_id, day_of_week)
        @hospital_unit_id = hospital_unit_id
        @day_of_week = day_of_week
      end

      def call
        PatientsDialysingByScheduleQuery.new(
          hospital_unit_id,
          schedule_definition_ids
        ).call
      end

      private

      def schedule_definition_ids
        Renalware::HD::ScheduleDefinition.for_day_of_week(day_of_week).pluck(:id)
      end
    end
  end
end
