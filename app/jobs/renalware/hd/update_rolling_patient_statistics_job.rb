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
      retry_on StandardError, wait: 1.hour, attempts: 2

      # :reek:UtilityFunction
      def perform(patient)
        UpdateRollingPatientStatistics.new(patient: patient).call
      end
    end
  end
end
