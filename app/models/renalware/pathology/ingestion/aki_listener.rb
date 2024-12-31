#
# When subscribed to HL7 `oru_message_arrived` messages, gets notified of incoming HL7 messages.
# Here we are interested only in AKI path results
#
module Renalware
  module Pathology
    module Ingestion
      class AKIListener
        class MessageDecorator
          pattr_initialize :hl7_message
          delegate_missing_to :hl7_message

          AKI_CODE = "AKI".freeze

          # Return the first AKI score found in any OBR in the message
          def score
            aki_observation&.value.to_f
          end

          def aki_date
            aki_observation&.observation_date
          end

          def hospital_centre_id
            sending_facility = hl7_message[:MSH].sending_facility # eg RAJ01
            Renalware::Hospitals::Centre.find_by(code: sending_facility)&.id
          end

          private

          def aki_observation
            @aki_observation ||= hl7_message
              .observation_requests
              .flat_map(&:observations)
              .detect { |obx| obx.identifier == AKI_CODE }
          end
        end

        # If the ORU messages has an AKI score then add the patient to RW if they are not already,
        # and give them the AKI modality.
        # NOTE: We are already inside a transaction here
        #
        # Logic:
        #
        # skip if age < 17
        # skip if curr modality is in hd, pd, death
        #
        # when score is 1
        #   alert if no alert within 14 days with any score (1,2,3)
        #
        # when score is 2 or 3
        #  alert if no alert in past 14 days
        #  alert if only score in previous 14 days was for a score of 1
        #  do not alert if alert in past 14 days was for a score of either 2 or 3
        #
        def oru_message_arrived(args)
          aki_msg = MessageDecorator.new(args[:hl7_message])
          return unless aki_msg.score > 0
          return if aki_msg.patient_identification.younger_than?(17)

          patient = find_or_create_patient(aki_msg)
          return unless current_modality_supports_aki_alerts?(patient)

          if aki_msg.score == 1
            return if any_recent_score_for?(patient)
          elsif aki_msg.score >= 2
            return if recent_score_is_2_or_3?(patient)
          end

          create_aki_alert(patient, aki_msg)
        end

        private

        def find_or_create_patient(hl7_message)
          patient = Feeds::PatientLocator.call(
            :oru,
            patient_identification: hl7_message.patient_identification
          )
          patient ||= add_patient_if_not_exists(hl7_message)
          assign_aki_modality_to(patient) if patient.current_modality.blank?
          patient
        end

        def current_modality_supports_aki_alerts?(patient)
          current_modality_code = patient.current_modality&.description&.code
          Modalities::Description
            .ignorable_for_aki_alerts
            .pluck(:code)
            .compact
            .exclude?(current_modality_code)
        end

        def any_recent_score_for?(patient)
          Renal::AKIAlert
            .where(patient_id: patient.id)
            .where(created_at: 14.days.ago..)
            .where(max_aki: 1..)
            .order(created_at: :desc)
            .exists?
        end

        def recent_score_is_2_or_3?(patient)
          Renal::AKIAlert
            .where(patient_id: patient.id)
            .where(created_at: 14.days.ago..)
            .group(:patient_id)
            .having("max(max_aki) >= ?", 2)
            .exists?
        end

        def assign_aki_modality_to(patient)
          cmd = Modalities::ChangePatientModality.new(patient: patient, user: SystemUser.find)
          cmd.call(description: aki_modality_description, started_on: Time.zone.now)
        end

        def create_aki_alert(patient, aki_message)
          pathset = ObservationSetPresenter.new(patient.current_observation_set)

          Renal::AKIAlert.create!(
            patient_id: patient.id,
            max_aki: aki_message.score,
            aki_date: aki_message.aki_date,
            max_cre: pathset.cre_result,
            cre_date: pathset.cre_observed_at,
            hospital_centre_id: aki_message.hospital_centre_id
          )
        end

        def aki_modality_description
          Renalware::Modalities::Description.find_by!("code ILIKE ?", "aki")
        end

        def add_patient_if_not_exists(hl7_message)
          Patients::Ingestion::Commands::AddPatient.call(hl7_message, "AKI")
        end
      end
    end
  end
end
