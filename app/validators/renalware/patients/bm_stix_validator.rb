module Renalware
  module Patients
    class BmStixValidator < ActiveModel::EachValidator
      include NumericRangeValidations
      include NumericScaleValidations
      MIN_VALUE = 0.5
      MAX_VALUE = 50
      MAX_DECIMAL_PLACES = 1

      def validate_each(record, attribute, value)
        return if value.blank?

        validate_number_is_in_range(record, attribute, value, MIN_VALUE, MAX_VALUE)
        validate_numeric_scale(record, attribute, value, MAX_DECIMAL_PLACES)
      end
    end
  end
end
