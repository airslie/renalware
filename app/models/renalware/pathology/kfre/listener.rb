# See KFRE (Kidney Failure Risk Equations):
# https://www.kidney.org/content/kidney-failure-and-kidney-failure-risk-equations-kfre-what-you-need-to-know
module Renalware
  module Pathology
    module KFRE
      class Listener
        # Broadcast by Renalware::Pathology::CreateObservationRequests
        # after an observation request and its child observations have been persisted
        # from an HL7 message.
        # We look for an ACR (Albumin-to-creatinine ratio) result and if found, and
        # the patient has a recent eGFR result, we generate 2 and 5 year KFRE scores and save them
        # as pathology results. We only do this if the patient's current modality supports KFRE
        # (i.e. not on dialysis or has a transplant).
        # We create a new observation request for the KFRE results with two child
        # observations, one for each of the 2 and 5 year results.
        # We use configured OBX codes for the ACR input and KFRE outputs.
        # See config/initializers/renalware.rb
        # We ignore ACR results of zero.
        #
        def after_observation_request_persisted(obr)
          return if Array(obr&.observations).empty?

          acr = obr.observations.detect { |obx| obx.description.code == acr_code }
          return if acr.blank? || acr.result.to_f.zero?

          kfre_patient = obr.patient.becomes(KFRE::Patient)
          if kfre_patient.current_modality_supports_kfre?
            generate_kfre(patient: kfre_patient, acr: acr)
          end
        end

        private

        def generate_kfre(patient:, acr:)
          kfre = KFRE::CalculateKFRE.call(
            sex: patient.sex&.code,
            age: patient.age,
            egfr: patient.latest_egfr,
            acr: acr.result.to_f
          )

          create_kfre_observations_for(patient, kfre, acr.observed_at) if kfre
        end

        def create_kfre_observations_for(patient, kfre, ts)
          request = patient.observation_requests.create!(
            description: find_or_create_kfre_request_desc,
            requested_at: ts,
            requestor_name: "Renalware"
          )
          request.observations.create!(description: y2_obs_desc, observed_at: ts, result: kfre.yr2)
          request.observations.create!(description: y5_obs_desc, observed_at: ts, result: kfre.yr5)
        end

        def find_or_create_kfre_request_desc
          RequestDescription.find_or_create_by!(
            code: Renalware.config.pathology_kfre_obr_code,
            lab: Lab.unknown
          ) do |obr|
            obr.name = Renalware.config.pathology_kfre_obr_code
          end
        end

        def y2_obs_desc
          find_or_create_obs_desc(Renalware.config.pathology_kfre_2y_obx_code)
        end

        def y5_obs_desc
          find_or_create_obs_desc(Renalware.config.pathology_kfre_5y_obx_code)
        end

        def find_or_create_obs_desc(code)
          ObservationDescription.find_or_create_by!(code: code) { |obr| obr.name = code }
        end

        def acr_code = @acr_code ||= Renalware.config.pathology_acr_obx_code_for_kfre_calculation
      end
    end
  end
end
