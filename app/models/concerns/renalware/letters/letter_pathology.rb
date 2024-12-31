module Renalware
  module Letters
    module LetterPathology
      extend ActiveSupport::Concern

      # Filters a set of observations using a specific set of OBX codes
      class FilteredObservationSet
        def initialize(observation_set:, codes: nil)
          @codes = codes || RelevantObservationDescription.all.map(&:code)
          @observation_set = observation_set
        end

        # Returns a hash of the filtered observations e.g.
        # {
        #   "NA"=>{"result"=>"139", "observed_at"=>"2016-03-15T03:28:00"},
        #   "ALB"=>{"result"=>"49", "observed_at"=>"2016-03-15T03:28:00"},
        #   ...
        # }
        def to_h
          return if observation_set.blank?

          hash = observation_set.values.select { |code, _| codes.include?(code.to_s) }
          hash.empty? ? nil : hash
        end

        private

        attr_reader :observation_set, :codes
      end

      # Update a letter's pathology snapshot to the current point in time
      def build_pathology_snapshot(patient)
        FilteredObservationSet.new(
          observation_set: patient.current_observation_set,
          codes: Renalware::Letters::RelevantObservationDescription.all.map(&:code)
        ).to_h
      end
    end
  end
end
