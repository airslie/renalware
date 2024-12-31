module Renalware
  module Pathology
    # A singleton exposing all defined OBX codes as an array of symbols
    class AllObservationCodes
      include Singleton

      # Example usage:
      #   AllObservationCodes.include?(code)
      def self.include?(code)
        instance.all.include?(code)
      end

      def all
        @all ||= ObservationDescription.order(:code).pluck(:code).map(&:upcase).map(&:to_sym)
      end
    end
  end
end
