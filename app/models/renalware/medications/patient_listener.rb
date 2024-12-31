module Renalware
  module Medications
    class PatientListener
      def patient_modality_changed_to_death(args)
        TerminateAllPatientPrescriptions.call(patient: args[:patient], by: args[:actor])
      end
    end
  end
end
