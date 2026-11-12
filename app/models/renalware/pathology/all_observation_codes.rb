module Renalware
  module Pathology
    # A singleton exposing all defined OBX codes as an array of symbols
    class AllObservationCodes
      include Singleton

      CACHE_KEY = "renalware/pathology/all_observation_codes".freeze

      def self.invalidate
        Rails.cache.delete(CACHE_KEY)
      end

      # Example usage:
      #   AllObservationCodes.include?(code)
      def self.include?(code)
        instance.all.include?(code)
      end

      def all
        Rails.cache.fetch(CACHE_KEY, expires_in: 1.hour) do
          ObservationDescription.order(:code).pluck(:code).map(&:upcase).map(&:to_sym)
        end
      end
    end
  end
end
