# When subscribed to HL7 `oru_message_arrived` messages, gets notified of incoming HL7 messages.
# Here we are interested only in ACR (Albumin-to-creatinine ratio) path results, from which we try
# and generate KFRE (Kidney Failure Risk Equations) scores and save as pathology results.
# See https://www.kidney.org/content/kidney-failure-and-kidney-failure-risk-equations-kfre-what-you-need-to-know
module Renalware
  module Pathology
    module KFRE
      class Listener
        class MessageDecorator
          pattr_initialize :hl7_message
          delegate_missing_to :hl7_message

          # ACR or PCR might be used, we make the OBX code to look for configurable
          def acr_code
            Renalware.config.pathology_acr_obx_code_for_kfre_calculation
          end

          # Return the first ACR found in any OBX in the message
          def acr
            acr_observation&.value.to_f
          end

          def acr_observed_at
            acr_observation&.observed_at
          end

          private

          def acr_observation
            @acr_observation ||= hl7_message
              .observation_requests
              .flat_map(&:observations)
              .detect { |obx| obx.identifier == acr_code }
          end
        end

        # If the ORU messages has an ACR (Albumin-to-creatinine ratio)
        def oru_message_arrived(args)
          msg = MessageDecorator.new(args[:hl7_message])
          generate_kfre(msg) if msg.acr.nonzero?
        end

        private

        def generate_kfre(msg)
          patient = KFRE::Patient.new(msg)

          if patient.current_modality_supports_kfre?
            kfre = KFRE::CalculateKFRE.call(
              sex: patient.sex&.code,
              age: patient.age,
              egfr: patient.latest_egfr,
              acr: msg.acr
            )

            create_kfre_observations_for(patient, kfre, msg.acr_observed_at) if kfre
          end
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
      end
    end
  end
end
