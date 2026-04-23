module Renalware
  module PD
    class PatientListener
      def patient_modality_changed_from_pd(args)
        return if args[:modality].description.to_sym == :pd

        TerminateCurrentRegime.new(patient: args[:patient]).call(
          by: args[:actor],
          terminated_on: args[:modality].started_on.to_date
        )
      end
    end
  end
end
