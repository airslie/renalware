require "age_calculator"

module Renalware
  class Age < NestedAttribute
    AGE_IN_MONTHS_THRESHOLD = 3 # If below this number of years, age must be in months

    attribute :amount, Integer
    attribute :unit, Document::Enum, enums: %i(years months)

    validate :validate_unit

    def self.age_in_months_threshold
      AGE_IN_MONTHS_THRESHOLD
    end

    def self.new_from(years:, months:, **)
      years = years&.to_i
      months = months&.to_i
      new.tap do |age|
        if years && months
          if years < age_in_months_threshold
            age.amount = (years * 12) + months
            age.unit = :months
          else
            age.amount = years
            age.unit = :years
          end
        end
      end
    end

    def to_s
      amount.present? ? "#{amount} #{unit.try(:text)}" : ""
    end

    private

    def validate_unit
      return if amount.blank?

      if amount.to_i < Age.age_in_months_threshold && unit.to_sym != :months
        errors.add(:unit, :invalid_unit)
      end
    end
  end
end
