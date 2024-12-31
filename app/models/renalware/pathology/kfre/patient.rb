module Renalware
  module Pathology
    module KFRE
      class Patient
        attr_reader :patient

        delegate_missing_to :patient

        def initialize(msg)
          @patient = Feeds::PatientLocator.call(
            :oru,
            patient_identification: msg.patient_identification
          )
          @patient = Pathology.cast_patient(@patient) if @patient
        end

        def current_modality_supports_kfre?
          return false unless patient

          current_modality_code = patient.current_modality&.description&.code
          Modalities::Description
            .ignorable_for_kfre
            .pluck(:code)
            .compact
            .exclude?(current_modality_code)
        end

        def latest_egfr
          patient.fetch_current_observation_set.values.egfr_result
        end
      end
    end
  end
end
