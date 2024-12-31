module Renalware
  module Patients
    class PulseValidator < ActiveModel::EachValidator
      include NumericRangeValidations
      MIN_VALUE = 20
      MAX_VALUE = 200

      def validate_each(record, attribute, value)
        return if value.blank?

        validate_number_is_in_range(record, attribute, value, MIN_VALUE, MAX_VALUE)
      end
    end
  end
end
