module Renalware
  module Pathology
    # A singleton exposing all defined OBX codes as an array of symbols.
    #
    # Codes are shared between processes via Rails.cache, and each process keeps its own
    # short-lived copy so that frequent lookups (e.g. ObservationSetMethods#method_missing)
    # do not hit the cache store every time. Committed changes to ObservationDescription codes
    # invalidate both layers in the committing process; other processes see the change once
    # their local copy expires (LOCAL_TTL).
    class AllObservationCodes
      include Singleton

      CACHE_KEY = "renalware/pathology/all_observation_codes".freeze
      SHARED_TTL = 1.hour
      LOCAL_TTL = 1.minute

      Snapshot = Data.define(:codes, :lookup, :expires_at) do
        def fresh?
          Time.current < expires_at
        end
      end

      # Delete the shared entry before dropping the local copy so a concurrent rebuild in this
      # process cannot repopulate the local copy from the stale shared entry.
      def self.invalidate
        Rails.cache.delete(CACHE_KEY)
        instance.reset
      end

      # Example usage:
      #   AllObservationCodes.include?(code)
      def self.include?(code)
        instance.include?(code)
      end

      def all
        snapshot.codes
      end

      def include?(code)
        snapshot.lookup.include?(code)
      end

      def reset
        @snapshot = nil
      end

      private

      def snapshot
        current = @snapshot
        return current if current&.fresh?

        @snapshot = build_snapshot
      end

      def build_snapshot
        codes = Rails.cache.fetch(CACHE_KEY, expires_in: SHARED_TTL) do
          ObservationDescription.order(:code).pluck(:code).map(&:upcase).map(&:to_sym)
        end.freeze

        Snapshot.new(codes:, lookup: codes.to_set.freeze, expires_at: LOCAL_TTL.from_now)
      end
    end
  end
end
