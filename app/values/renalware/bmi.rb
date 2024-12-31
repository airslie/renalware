module Renalware
  # Value object representing Body Mass Index. Accepts only meters and kg
  #
  # Example usage:
  #   bmi = Renalware::BMI.new(height: 1.80, weight: 180)
  #   bmi.to_f # => 55.6
  #   bmi.to_s # => "55.6"
  #
  class BMI
    pattr_initialize [:weight!, :height!]
    delegate :to_s, to: :to_f

    def to_f
      return unless weight && height && height > 0

      ((weight / height) / height).round(1)
    end
  end
end
