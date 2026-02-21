module Renalware
  module Pathology
    class ObservationForPatientObservationDescriptionUsingSetQuery
      pattr_initialize :patient, :observation_description_code

      # Fetches the patient's most recent observation for the supplied observation_description.code
      # (eg 'HGB') using the patient's current_observation_set jsonb hash and returnd something
      # like { "result" => "123", "observed_on" => "2019-01-01" }
      def call
        return {} unless patient.current_observation_set

        patient.current_observation_set.values.fetch(observation_description_code, {})
      end
    end
  end
end
