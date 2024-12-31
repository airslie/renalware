module Renalware
  module NumericScaleValidations
    extend ActiveSupport::Concern
    def validate_numeric_scale(record, attribute, value, scale)
      if number_exceeds_scale?(value, scale)
        record.errors.add(attribute, :invalid_number)
      end
    end

    # Returns true for any integer or number to _scale_ decimal places
    # e.g. if scale is 1 then 11 or 11.1 return true but 11.11 returns false
    def number_exceeds_scale?(value, scale)
      value.to_f.round(scale) != value.to_f
    end
  end
end
