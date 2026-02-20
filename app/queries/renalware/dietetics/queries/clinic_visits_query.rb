module Renalware
  module Dietetics
    module Queries
      class ClinicVisitsQuery
        DEFAULT_LIMIT = 100

        def call(patient:, limit: DEFAULT_LIMIT)
          Renalware::Clinics
            .cast_patient(patient)
            .clinic_visits
            .where(type: Renalware::Dietetics::ClinicVisit.name)
            .limit(limit)
        end
      end
    end
  end
end
