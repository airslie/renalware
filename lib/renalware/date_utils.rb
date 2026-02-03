module Renalware
  module DateUtils
    module_function

    def to_date(value)
      return value if value.is_a?(Date)
      return Time.zone.parse(value).to_date if value.is_a?(String)

      value&.to_date
    rescue ArgumentError
      nil
    end
  end
end
