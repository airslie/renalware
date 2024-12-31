module Renalware
  module Pathology
    # A utility class used for example by the host app to provide a generic way of adjusting
    # an observation, usually in a Wisper listener on receipt of a broadcast pathology message
    # probably 'after_observation_request_persisted'.
    #
    # Example usage:
    #
    # # Subscribe our class to pathology messages.
    # Renalware.configure do |config|
    #   map = config.broadcast_subscription_map
    #   map["Renalware::Pathology::CreateObservationRequests"] << "MyListener"
    # end
    #
    # class MyListener
    #   def after_observation_request_persisted(observation_request)
    #     service = Renalware::Pathology::AdjustObservation.new(
    #       observation_request: observation_request,
    #       code: "EGFR",
    #       policy: ->(patient, observation){
    #         .. some logic returning true or false to indicate to adjust or not
    #       }
    #     )
    #     service.call do |egfr_observation_requiring_adjustment|
    #       egfr_observation_requiring_adjustment.result += 1 or whatever
    #       egfr_observation_requiring_adjustment.comment = "adjusted (original = 123)"
    #       egfr_observation_requiring_adjustment.save!
    #     end
    #   end
    # end
    class AdjustObservation
      pattr_initialize [:observation_request!, :code!, :policy!]
      delegate :patient, to: :observation_request

      # Will yield the requested observation if one found - the caller is responsible for
      # making and saving the adjustment.
      def call
        return unless request_has_the_relevant_observation?
        return if observation_result_is_zero?
        return unless adjustment_required?

        yield observation
      end

      def request_has_the_relevant_observation?
        observation.present?
      end

      def observation_result_is_zero?
        observation.result.to_f.zero?
      end

      def adjustment_required?
        policy.call(patient, observation)
      end

      def observation
        @observation ||= begin
          observation_request
            .observations
            .joins(:description)
            .find_by(
              pathology_observation_descriptions: { code: code }
            ) || Renalware::NullObject.instance
        end
      end
    end
  end
end
