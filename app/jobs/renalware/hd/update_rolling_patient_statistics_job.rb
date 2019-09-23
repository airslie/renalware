# frozen_string_literal: true

# When executed this job updates rolling statistics for a patient's
# last past 12 HD sessions.
# Because this job will be triggered again the next time an HD Sessions is
# created, it is not crucial to keep each event around - ie they have a short
# shelf-life. For this reason we only retry 3 times then delete failed jobs.
module Renalware
  module HD
    class UpdateRollingPatientStatisticsJob < ApplicationJob
      queue_as :hd_patient_statistics
      queue_with_priority 4

      # :reek:UtilityFunction
      def perform(patient)
        UpdateRollingPatientStatistics.new(patient: patient).call
      end

      def max_attempts
        3
      end

      def destroy_failed_jobs?
        true
      end
    end
  end
end
