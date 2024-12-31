module Renalware
  module Pathology
    # A view model representing the aggregation of observations by date.
    #
    class Results
      attr_reader :observation_descriptions

      def initialize(observations, observation_descriptions)
        @observations = observations
        @observation_descriptions = observation_descriptions
      end

      def map(&)
        to_a.map(&)
      end

      def to_a
        observations_by_date.map do |observed_on, observations_of_the_same_date|
          build_row(observed_on, observations_of_the_same_date, observation_descriptions)
        end
      end

      private

      def observations_by_date
        @observations.group_by { |observation| observation.observed_at.to_date }
      end

      def build_row(observed_on, observations, descriptions)
        RowBuilder.new(observed_on, observations, descriptions).call
      end

      # Responsible for building a row of observation results for a specific
      # date.
      #
      class RowBuilder
        def initialize(observed_on, observations, descriptions)
          @observed_on = observed_on
          @observations = observations
          @descriptions = descriptions
        end

        # @return [Hash] representing a collection of observations results for a specific date
        #
        # Example:
        #
        # {Date.parse("2016-10-10") => [Observation.new(result: ""), Observation.new(result: "4")]}
        #
        def call
          observations = @descriptions.map do |description|
            find_observation_result_by_description(description) ||
              null_observation_for_description(description)
          end

          { @observed_on => observations }
        end

        private

        # @param  [ObservationDescription]
        # @return [Observation] representing the observation result for the ObservationDescription,
        #                       if none is found, a nil returned.
        #
        def find_observation_result_by_description(description)
          @observations.detect { |observation| observation.description == description }
        end

        def null_observation_for_description(description)
          Observation.new(description: description, result: "")
        end
      end
    end
  end
end
