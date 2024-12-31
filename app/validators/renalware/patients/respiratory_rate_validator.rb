module Renalware
  module Patients
    class RespiratoryRateValidator < ActiveModel::EachValidator
      include NumericRangeValidations
      MIN_VALUE = 4
      MAX_VALUE = 40

      def validate_each(record, attribute, value)
        return if value.blank?

        validate_number_is_in_range(record, attribute, value, MIN_VALUE, MAX_VALUE)
      end
    end
  end
end
