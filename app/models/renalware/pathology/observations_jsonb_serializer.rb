module Renalware
  module Pathology
    # We mix this module into any database-returned jsonb hash of observations
    # (e.g. CurrentObservationSet.values and Letter.pathology_snapshot)
    module ObservationSetMethods
      VALID_SUFFIXES = %w(_result _observed_at).freeze

      # Support these syntaxes
      #   values.hgb # => { result: ... observed_at: ...}
      #   values.HGB # => { result: ... observed_at: ...}
      #   values.hgb_result # => 3.3
      #   values.hgb_observed_at # => "2017-17-01"
      # So the values has methods corresponding to the entire set of possible
      # OBX codes, and also methods to reach in and get their result and observed_at date.
      def method_missing(method_name, *_args, &)
        code, suffix = method_parts(method_name)
        if VALID_SUFFIXES.include?(suffix) || AllObservationCodes.include?(code)
          observation_hash_or_hash_element_for(code, suffix)
        else
          super
        end
      end

      # From eg hgb_result, returns
      # [:HGB, "result"]
      def method_parts(method_name)
        matches = method_name.to_s.match(/([^_]*)(\w*)/)
        [matches[1]&.upcase&.to_sym, matches[2]]
      end

      def observation_hash_or_hash_element_for(code, suffix)
        obs_hash = self[code]
        return nil if obs_hash.blank? # patient may not have this code in the set, or it might be {}
        return obs_hash[:result] if suffix == "_result"
        return Date.parse(obs_hash[:observed_at]) if suffix == "_observed_at"

        obs_hash
      end
    end

    class ObservationsJsonbSerializer
      def self.dump(hash)
        JSON.parse hash.to_json
      end

      def self.load(hash)
        type_check(hash)
          .with_indifferent_access
          .extend(ObservationSetMethods)
      end

      def self.type_check(hash)
        if hash.nil? then {}
        elsif hash.is_a?(Hash) then hash
        else
          JSON.parse(hash)
        end
      end
    end
  end
end
