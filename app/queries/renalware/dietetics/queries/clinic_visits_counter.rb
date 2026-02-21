module Renalware
  module Dietetics
    module Queries
      class ClinicVisitsCounter
        def call(patient:)
          Renalware::Clinics
            .cast_patient(patient)
            .clinic_visits
            .where(type: Renalware::Dietetics::ClinicVisit.name)
            .count
        end
      end
    end
  end
end
