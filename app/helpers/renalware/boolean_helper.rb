module Renalware
  module BooleanHelper
    def yes_no(bool)
      bool ? "Yes" : "No"
    end

    def yes_no_if_set(bool)
      return if bool.nil?

      yes_no(bool)
    end
  end
end
