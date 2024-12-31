module Renalware
  module UKRDC
    module TreatmentTimeline
      module HD
        # Decorates an HD::Profile, adding methods that detect any changes significant enough
        # to warrant generating a new UKRDC Treatment.
        class ProfileDecorator < DumbDelegator
          def initialize(profile, last_profile: nil)
            @last_profile = last_profile
            super(profile)
          end

          def hd_type
            document.dialysis.hd_type
          end

          def changed?
            return true if last_profile.blank?

            hd_type_changed? || hospital_unit_changed?
          end

          def unchanged?
            !changed?
          end

          def hd_type_changed?
            last_profile.document.dialysis.hd_type != hd_type
          end

          def hospital_unit_changed?
            last_profile.hospital_unit_id != hospital_unit_id
          end

          private

          attr_reader :last_profile
        end
      end
    end
  end
end
