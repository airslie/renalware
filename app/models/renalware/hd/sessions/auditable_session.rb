# A Session decorator adding methods that derive statistical data for use in auditing.
# See also AuditableSessionCollection
#
# Example usage:
#  auditable_session = AuditableSession.new(session)
#  auditable_session.weight_loss => 0.91
#

module Renalware
  module HD
    module Sessions
      class AuditableSession < SimpleDelegator
        delegate :observations_before, :observations_after, to: :document

        def blood_pressure_measurements
          [
            observations_before.blood_pressure,
            observations_after.blood_pressure
          ]
        end

        def profile
          super || NullObject.instance
        end

        def dry_weight
          super || NullObject.instance
        end

        def document
          return SessionDocument.new if dna?

          super || SessionDocument.new
        end

        # Note the profile here might be a NullHDProfile which will always return 0 for the
        # prescribed time - so sessions with a missing profile always report a
        # dialysis_time_shortfall of 0
        def dialysis_minutes_shortfall
          prescribed_time == 0 ? 0 : prescribed_time - duration
        end

        def dialysis_minutes_shortfall_percentage
          return 0.0 if dialysis_minutes_shortfall == 0

          (dialysis_minutes_shortfall.to_f / prescribed_time.to_f) * 100.0
        end

        def dialysis_minutes_shortfall_gt_5_pct?
          dialysis_minutes_shortfall_percentage > 5.0
        end

        def weight_loss
          pre_weight = observations_before.weight.to_f
          post_weight = observations_after.weight.to_f

          return if pre_weight.zero? || post_weight.zero?

          observations_before.weight.to_f - observations_after.weight.to_f
        end

        def weight_loss_as_percentage_of_body_weight
          return if measured_dry_weight.zero? || weight_loss.to_f.zero?

          (weight_loss / measured_dry_weight) * 100.0
        end

        # This is fluid removed (ml) / HD time in hours eg 3.75 / dry weight (kg)
        # The result is in ml/hr/kg.
        # Note that fluid removed is entered in L so we need to convert to ml here.
        def ufr
          return nil unless measured_dry_weight > 0 && duration > 0 && fluid_removed > 0

          (fluid_removed * 1000) / duration_as_hours / measured_dry_weight
        end

        private

        def prescribed_time
          profile.prescribed_time.to_i
        end

        def measured_dry_weight
          dry_weight.weight.to_f
        end

        def duration_as_hours
          duration.to_f / 60.0
        end

        def fluid_removed
          document.dialysis.fluid_removed.to_f
        end
      end
    end
  end
end
