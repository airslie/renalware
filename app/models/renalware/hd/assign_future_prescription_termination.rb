module Renalware
  module HD
    # Assign a future termination to an HD prescription if configured to do so.
    #
    # Prescriptions which are administer_on_hd = true should automatically have a future
    # termination according to config.auto_terminate_hd_prescriptions_after_period.
    # If this behaviour is not required, return nil in the setting.
    # If administer_on_hd = true and stat = true then it should automatically have a future
    # termination according to config.auto_terminate_hd_stat_prescriptions_after_period.
    # If this behaviour is not required, return nil in the setting.
    class AssignFuturePrescriptionTermination
      include Callable
      pattr_initialize [:prescription!, :by!]

      def call
        termination = prescription.termination
        return unless prescription.administer_on_hd?
        return if prescription.prescribed_on.blank?
        return if termination_period.nil?
        return if termination&.terminated_on_set_by_user?

        if termination.present?
          termination.assign_attributes(termination_attributes)
        else
          prescription.build_termination(termination_attributes)
        end
      end

      private

      def termination_period
        @termination_period ||= begin
          if prescription.stat? # single administration
            Renalware.config.auto_terminate_hd_stat_prescriptions_after_period
          else
            Renalware.config.auto_terminate_hd_prescriptions_after_period
          end
        end
      end

      def termination_notes
        "HD prescription scheduled to terminate #{termination_period.in_days.to_i} days from start"
      end

      def termination_attributes
        {
          terminated_on: prescription.prescribed_on + termination_period,
          notes: termination_notes,
          by: by
        }
      end
    end
  end
end
