module Renalware
  module PD
    class AdequacyCalculatedAttributes
      pattr_initialize [:adequacy!, :age!, :sex!]

      delegate :urine_urea,
               :height,
               :weight,
               :urine_creatinine,
               :urine_24_vol,
               :dialysate_urea,
               :dialysate_creatinine,
               :dial_24_vol_out,
               :dial_24_missing,
               :serum_urea,
               :serum_creatinine,
               :urine_24_missing,
               to: :adequacy,
               allow_nil: true

      def to_h
        return {} unless adequacy

        {
          total_creatinine_clearance: total_creatinine_clearance,
          pertitoneal_creatinine_clearance: pertitoneal_creatinine_clearance,
          renal_creatinine_clearance: residual_renal_function,
          total_ktv: total_ktv,
          pertitoneal_ktv: pertitoneal_ktv,
          renal_ktv: renal_ktv,
          dietry_protein_intake: dietry_protein_intake
        }
      end

      def renal_urine_clearance
        return if urine_24_missing
        return 0.0 if urine_24_vol&.zero?
        return if any_are_nil_or_zero?(urine_urea, serum_urea, urine_24_vol)

        (urine_urea * urine_24_vol / 1000.0) / serum_urea * 7.0
      end

      def renal_creatinine_clearance
        return if urine_24_missing
        return 0.0 if urine_24_vol&.zero?
        return if any_are_nil_or_zero?(urine_creatinine, serum_creatinine, urine_24_vol)

        (
          (urine_creatinine * urine_24_vol) / serum_creatinine * 7.0
        ).round(2)
      end

      def residual_renal_function
        return 0.0 if renal_creatinine_clearance&.zero?
        return 0.0 if renal_urine_clearance&.zero?
        return if any_are_nil_or_zero?(body_surface_area, renal_urine_clearance)

        (
          (renal_creatinine_clearance + renal_urine_clearance) / (2.0 * body_surface_area) * 1.72
        ).to_i
      end

      def pertitoneal_creatinine_clearance
        return if dial_24_missing
        return if any_are_nil_or_zero?(
          dial_24_vol_out,
          serum_creatinine,
          dialysate_creatinine,
          body_surface_area
        )

        (
          (dialysate_creatinine * dial_24_vol_out / 1000.0) /
          serum_creatinine * 7.0 * 1.72 / body_surface_area
        ).to_i
      end

      def total_creatinine_clearance
        return if residual_renal_function.nil? || pertitoneal_creatinine_clearance.nil?

        residual_renal_function.to_f + pertitoneal_creatinine_clearance.to_f
      end

      def dietry_protein_intake
        return if urine_24_missing || dial_24_missing
        return if any_are_nil_or_zero?(
          dialysate_urea,
          dial_24_vol_out,
          urine_urea,
          urine_24_vol,
          weight
        )

        (
          (
            19.0 + 0.272 *
            (
              (dialysate_urea * dial_24_vol_out / 1000.0) + (urine_urea * urine_24_vol / 1000.0)
            )
          ) / weight
        ).round(2)
      end

      def renal_ktv
        return if urine_24_missing
        return 0.0 if urine_24_vol&.zero?
        return if any_are_nil_or_zero?(
          urine_urea,
          serum_urea,
          urine_24_vol,
          total_body_water
        )

        (
          (urine_urea / serum_urea * urine_24_vol / 1000.0 * 7.0) / total_body_water.to_f
        ).round(2)
      end

      def pertitoneal_ktv
        return if dial_24_missing
        return if any_are_nil_or_zero?(
          serum_urea,
          dialysate_urea,
          dial_24_vol_out,
          total_body_water
        )

        (
          (dialysate_urea / serum_urea * dial_24_vol_out / 1000.0 * 7.0) / total_body_water.to_f
        ).round(2)
      end

      def total_ktv
        return if renal_ktv.nil? || pertitoneal_ktv.nil?

        (renal_ktv.to_f + pertitoneal_ktv.to_f).round(2)
      end

      def body_surface_area
        Clinics::BodySurfaceArea.calculate(weight: weight, height: height)
      end

      def total_body_water
        Clinics::TotalBodyWater.calculate(height: height, weight: weight, age: age, sex: sex)
      end

      private

      def any_are_nil_or_zero?(*attrs)
        Array(attrs).map(&:to_f).any?(&:zero?)
      end
    end
  end
end
