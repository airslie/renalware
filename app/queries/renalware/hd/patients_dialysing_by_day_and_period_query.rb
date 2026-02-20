# Find for example HD Patients who according to their HD Profile dialyse on Monday PM
# Example usage in that instance:
#   PatientsDialysingByDayAndPeriodQuery.new(1, "am").call
module Renalware
  module HD
    class PatientsDialysingByDayAndPeriodQuery
      attr_reader :hospital_unit_id, :day_of_week, :period_code

      def initialize(hospital_unit_id, day_of_week, period_code)
        @hospital_unit_id = hospital_unit_id
        @day_of_week = day_of_week
        @period_code = period_code
      end

      def call
        PatientsDialysingByScheduleQuery.new(
          hospital_unit_id,
          schedule_definition_ids
        ).call
      end

      private

      # Find the first schedule having day_of_week in the pg days[] array (e.g. [2,4,6] if
      # day_of_week is 2 (Tuesday) AND matching the period_code ie having the correct diurnal
      # period code e.g. AM.
      # Note
      def schedule_definition_ids
        HD::ScheduleDefinition
          .eager_load(:diurnal_period)
          .merge(Renalware::HD::DiurnalPeriodCode.for(period_code))
          .merge(Renalware::HD::ScheduleDefinition.for_day_of_week(day_of_week))
          .pluck(:id)
      end
    end
  end
end
