module Renalware
  module Clinical
    class HeaderPresenter
      pattr_initialize :patient
      delegate :weight, :height, :blood_pressure, :bmi, to: :clinical_current_observations
      delegate :measurement, :date, to: :weight, prefix: true
      delegate :measurement, :date, to: :height, prefix: true
      delegate :measurement, :date, to: :blood_pressure, prefix: true
      delegate :measurement, :date, to: :bmi, prefix: true

      def current_pathology
        @current_pathology ||= pathology_current_observation_set.values
      end

      private

      def pathology_current_observation_set
        pathology_patient.current_observation_set || Pathology::NullObservationSet.new
      end

      def pathology_patient
        Pathology.cast_patient(patient)
      end

      def clinical_current_observations
        @clinical_current_observations ||= Clinics::CurrentObservations.new(patient)
      end
    end
  end
end
