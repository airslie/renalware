# Compares two hashes of pathology observations (OBXs).
# Used for example in a Letter, where a snapshot of pathology is stored on the letter,
# but when the letter we compare the snapshot to the latest hash in the jsonb column
# CurrentObservationSet#values to see if there are newer results that the user might want
# to bring into the letter.
#
# NB: uses Rails 5 `render anywhere` feature.
module Renalware
  module Pathology
    class ObservationsDiff
      pattr_initialize [:patient!, :observation_set_a!, :observation_set_b!, :descriptions!]

      def changes?
        @changes
      end

      def to_html
        render
      end

      class Observation
        delegate :any?, :to_h, to: :hash

        def initialize(hash)
          @hash = hash
        end

        def result
          hash.fetch(:result, 0)
        end

        def observed_at
          Time.zone.parse(hash.fetch(:observed_at, "1970-01-01"))
        end

        def supercedes?(other)
          (observed_at > other.observed_at) ||
            ((observed_at == other.observed_at) && result != other.result)
        end

        private

        attr_reader :hash
      end

      # Given two hashes like this
      # {
      #   HGB: { result: 2.1, observed_at: "2017-12-12 00:01:01"},
      #   CRE: { result: 9, observed_at: "2017-12-12 00:01:01"}
      # }
      # {
      #   HGB: { result: 1.0, observed_at: "2018-12-12 00:01:01"}, # changed
      #   CRE: { result: 1.1, observed_at: "2017-12-11 00:01:01"}, # no change!
      #   PTH: { result: 1.1, observed_at: "2017-12-11 00:01:01"}  # new!
      # }
      # Return a hash that looks like this
      # {
      #   HGB: [
      #     { result: 2.1, observed_at: "2017-12-12 00:01:01"}, # original
      #     { result: 1.0, observed_at: "2018-12-12 00:01:01"}, # changed
      #     -1.1 # digg
      #   ],
      #   CRE: [
      #     { result: 9, observed_at: "2017-12-12 00:01:01"},
      #     nil, # no new value
      #     nil # no change
      #   ],
      #   PTH: [
      #     nil, # no original
      #     { result: 1.1, observed_at: "2017-12-11 00:01:01"}  # new!
      #     1.1
      #  ]
      # }
      # rubocop:disable Metrics/AbcSize
      def to_h
        return {} if observation_set_a.blank? && observation_set_a.blank?

        filtered_observation_set_a = filter_observations_by_descriptions(observation_set_a)
        filtered_observation_set_b = filter_observations_by_descriptions(observation_set_b)

        description_codes.each_with_object({}) do |code, hash|
          obs_a = Observation.new(filtered_observation_set_a.fetch(code, {}))
          obs_b = Observation.new(filtered_observation_set_b.fetch(code, {}))

          arr = Array.new(3)
          arr[0] = obs_a if obs_a.any?

          if obs_b.supercedes?(obs_a)
            arr[1] = obs_b
            arr[2] = obs_b.result.to_f - obs_a.result.to_f
          end

          hash[code] = arr
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      def filter_observations_by_descriptions(observations)
        observations.select { |code, _obs| description_codes.include?(code.to_sym) }
      end

      def description_codes
        @description_codes ||= descriptions.map(&:code).map(&:to_sym)
      end

      def render
        renderer.render(
          partial: "renalware/pathology/observations/diff",
          locals: {
            patient: patient,
            diff: self
          }
        )
      end

      def renderer
        ApplicationController.renderer
      end
    end
  end
end
