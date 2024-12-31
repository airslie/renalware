module Renalware
  module Patients
    class HeightValidator < ActiveModel::EachValidator
      include NumericRangeValidations
      include NumericScaleValidations
      MIN_VALUE = 0.20
      MAX_VALUE = 2.50
      MAX_DECIMAL_PLACES = 2

      def validate_each(record, attribute, value)
        return if value.blank?

        validate_number_is_in_range(record, attribute, value, MIN_VALUE, MAX_VALUE)
        validate_numeric_scale(record, attribute, value, MAX_DECIMAL_PLACES)
      end
    end
  end
end
