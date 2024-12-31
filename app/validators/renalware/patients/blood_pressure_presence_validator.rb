# This validator is used somewhat unconventionally from the parent object (e.g. a
# the HD::SessionDocument::Dialysis class) to allow us to conditionally validate
# the presence of the BloodPressure fields only if a condition external to the BloodPressure
# class is met.
# It might be prudent to look at moving this sort of validation logic to a
# form object in the future.
module Renalware
  module Patients
    class BloodPressurePresenceValidator < ActiveModel::EachValidator
      def validate_each(_record, _attribute, value)
        blood_pressure = value
        errors = blood_pressure.errors
        errors.add(:systolic, :blank) if blood_pressure.systolic.blank?
        errors.add(:diastolic, :blank) if blood_pressure.diastolic.blank?
      end
    end
  end
end
