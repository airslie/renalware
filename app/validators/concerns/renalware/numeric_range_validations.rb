module Renalware
  module NumericRangeValidations
    extend ActiveSupport::Concern
    def validate_number_is_in_range(record, attribute, number, min, max)
      if number.to_f < min || number.to_f > max
        record.errors.add(attribute, :out_of_range)
      end
    end
  end
end
