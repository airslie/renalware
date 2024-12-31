module Renalware
  module UKRDC
    module TreatmentTimeline
      module HD
        # Generates a set of treatments based on an HD modality and any HD::Profiles
        # during the span of that modality.
        #
        # There will be an initial treatment triggered by the modality itself, and then
        # a treatment for each significant change in the HD::Profile during the period of the
        # modality (ie until it ends).
        #
        # Note that the first HD Profile associated with any HD Modality is determined in the SQL
        # view hd_profile_for_modalities. Test with
        #   select * from hd_profile_for_modalities;
        # It looks ahead to find the very first HD profile.
        #
        class Generator
          pattr_initialize :modality
          delegate :patient, to: :modality

          def call
            create_treatment_from_modality
            create_treatments_within_modality
          end

          private

          def create_treatment_from_modality
            create_treatment(
              hd_profile_at_start_of_modality,
              modality.started_on,
              modality.ended_on
            )
          end

          def create_treatment(profile, start_date, end_date)
            treatments << Treatment.create!(
              patient: patient,
              clinician: modality.created_by,
              started_on: start_date,
              modality_id: modality.id,
              modality_description_id: modality.description_id,
              hospital_unit: profile&.hospital_unit,
              ended_on: end_date,
              modality_code: ukrdc_modality_code_from_profile(profile),
              hd_profile: profile,
              hd_type: profile&.document&.dialysis&.hd_type
            )

            # Update the end date on the previous treatment - ie the one we just added is
            # taking over as the currently active treatment
            if treatments.length > 1
              previous_treatment = treatments[treatments.length - 2]
              # p "updating end date from #{previous_treatment.ended_on} to #{start_date}"
              previous_treatment.update!(ended_on: start_date)
            end
          end

          # Find the modality that was active on the day of the modality change
          # The profile might have been added up to say 14 days later however so if there is none
          # active on the day the modality was created, search up to 14 days ahead until we find
          # one. Return nil if none found.
          # Its complicated a bit by the fact that although there is a prescribed_on in the
          # hd_profile, it is sometimes missing so we need to default to created_at in that
          # instance.
          def hd_profile_at_start_of_modality
            @hd_profile_at_start_of_modality ||= begin
              hd_profile_id = Renalware::HD::ProfileForModality.find_by!(
                modality_id: modality.id
              ).hd_profile_id
              return if hd_profile_id.blank?

              HD::ProfileDecorator.new(
                Renalware::HD::Profile.with_deactivated.find(hd_profile_id)
              )
            end
          end

          # 3 things trigger a new Treatment for an HD patient
          # - change of site
          # - change of hd_type to from hd and (hdf_pre || hdf_post)
          # - change of hd prescription
          # Loop through the hd_profiles and trigger a new treatment when any of these change
          # There is a problem here as we are creating duplicate treatments
          # I think we need to first find the hd profile that is associated with the hd modality
          # and that becomes the 'last_profile' here
          def create_treatments_within_modality
            last_profile = hd_profile_at_start_of_modality
            hd_profiles.each do |profile_|
              profile = HD::ProfileDecorator.new(profile_, last_profile: last_profile)
              create_treatment_from(profile) # if last_profile.nil? || profile.changed?
              last_profile = profile
            end
          end

          def hd_profiles
            profiles = Renalware::HD::ProfilesInDateRangeQuery.new(
              patient: patient,
              from: modality.started_on,
              to: modality.ended_on
            ).call

            profiles -= [hd_profile_at_start_of_modality]
            profiles
          end

          def create_treatment_from(profile)
            start_date = profile.created_at.presence || modality.started_on
            end_date = profile.deactivated_at.presence || modality.ended_on

            create_treatment(profile, start_date, end_date)
          end

          def treatments
            @treatments ||= []
          end

          def hd_patient
            Renalware::HD.cast_patient(patient)
          end

          def ukrdc_modality_code_from_profile(profile)
            ModalityCodeMap.new.code_for_profile(profile)
          end
        end
      end
    end
  end
end
