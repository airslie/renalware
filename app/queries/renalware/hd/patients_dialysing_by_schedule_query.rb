module Renalware
  module HD
    class PatientsDialysingByScheduleQuery
      attr_reader :hospital_unit_id, :schedule_definition_ids

      def initialize(hospital_unit_id, schedule_definition_ids)
        @hospital_unit_id = hospital_unit_id
        @schedule_definition_ids = Array(schedule_definition_ids)
      end

      def call
        return [] if schedule_definition_ids.empty?

        Patient
          .eager_load(hd_profile: [:hospital_unit, { schedule_definition: [:diurnal_period] }])
          .where(
            hd_profiles: {
              schedule_definition_id: schedule_definition_ids,
              hospital_unit_id: hospital_unit_id
            }
          )
          .order(:family_name, :given_name)
      end
    end
  end
end
