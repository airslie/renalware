require "age_calculator"

module Renalware
  class AutomaticAgeCalculator
    def initialize(age, born_on:, age_on_date:)
      @age = age
      @born_on = born_on
      @age_on_date = age_on_date
    end

    def compute
      if @born_on.present?
        parts = AgeCalculator.new.compute(@born_on, @age_on_date)
        Age.new_from(**parts)
      else
        @age
      end
    end
  end
end
