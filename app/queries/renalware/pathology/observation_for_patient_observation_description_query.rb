module Renalware
  module Pathology
    class ObservationForPatientObservationDescriptionQuery
      pattr_initialize :patient, :observation_description

      def call
        patient
          .observations
          .where(description: observation_description)
          .order(observed_at: :desc)
          .first
      end
    end
  end
end
