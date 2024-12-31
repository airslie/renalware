module Renalware
  module HD
    class GenerateMonthlyStatisticsForPatient
      def initialize(patient:, period:)
        @patient = patient
        @period = period
      end

      def call
        options = { patient: patient, period: period }
        sessions = Sessions::AuditablePatientSessionsInPeriodQuery.new(**options).call
        create_patient_statistics(sessions)
      end

      private

      attr_reader :period, :patient

      def create_patient_statistics(sessions)
        return unless sessions.any?

        stats = build_patient_statistics
        stats.hospital_unit = most_recently_used_hospital_unit(sessions)
        stats.assign_attributes(auditable_sessions(sessions).to_h)
        stats.session_count = sessions.length
        stats.pathology_snapshot = capture_pathology_snapshot
        stats.save!
      end

      def build_patient_statistics
        PatientStatistics.where(
          patient: patient,
          month: period.month,
          year: period.year,
          rolling: nil
        ).first_or_initialize
      end

      def auditable_sessions(sessions)
        Sessions::AuditableSessionCollection.new(sessions)
      end

      def most_recently_used_hospital_unit(sessions)
        sessions.last&.hospital_unit
      end

      def capture_pathology_snapshot
        FilteredObservationSet.new(patient: patient).to_h
      end

      # Filters a set of observations using a specific set of OBX codes.
      # The snapshot is stored on the hd_patient_statistics table - i.e. it represents
      # the state of the patient's pathology *at the time the hd_stats row is created*.
      # So for an hd_stats row for say Patient X in the month of April 2018, the
      # pathology_snapshot is a frozen snapshot of their pathology at 30/4/2018 23:59
      # TODO: de-dupe this with the other FilteredObservationSet in Letters::?
      class FilteredObservationSet
        # These are the codes for the results we want to store in
        # hd_patient_statics.pathology_snapshot - we are only interested in these
        # results. They will be used for instance in reporting_hd_overall_audit
        CODES = %w(HGB PTHI PHOS CRE URE URR).freeze

        def initialize(patient:)
          @observation_set = Pathology.cast_patient(patient).fetch_current_observation_set
        end

        # Returns a hash of the filtered observations e.g.
        # {
        #   "HGB"=>{"result"=>"139", "observed_at"=>"2016-03-15T03:28:00"},
        #   "URR"=>{"result"=>"49", "observed_at"=>"2016-03-15T03:28:00"},
        #   ...
        # }
        def to_h
          return {} if observation_set.blank?

          observation_set.values.select { |code, _| CODES.include?(code.to_s) }
        end

        private

        attr_reader :observation_set
      end
    end
  end
end
