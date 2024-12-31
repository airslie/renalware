module Renalware
  module Patients
    class BloodPressureValidator < ActiveModel::Validator
      include NumericRangeValidations
      MIN_VALUE = 20
      MAX_VALUE = 300

      def validate(bp)
        apply_validations(bp) if bp.present?
      end

      private

      def apply_validations(bp)
        validate_number_is_in_range(bp, :systolic, bp.systolic, MIN_VALUE, MAX_VALUE)
        validate_number_is_in_range(bp, :diastolic, bp.diastolic, MIN_VALUE, MAX_VALUE)
        validate_diastolic_less_than_systolic(bp)
      end

      def validate_diastolic_less_than_systolic(bp)
        errors = bp.errors
        return if errors.any?

        unless bp.diastolic.to_f < bp.systolic.to_f
          errors.add(:diastolic, :must_be_less_than_systolic)
        end
      end
    end
  end
end
