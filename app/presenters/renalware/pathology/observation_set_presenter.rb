# frozen_string_literal: true

module Renalware
  module Pathology
    class ObservationSetPresenter < DumbDelegator
      class Observation
        attr_reader_initialize [:code, :description, :result, :observed_at]
      end

      def method_missing(method_name, **_args, &_block)
        return if __getobj__.nil?

        vals = __getobj__.values
        vals.public_send(method_name)
      end

      def respond_to_missing?(method_name, _include_private = false)
        (values.present? && values.respond_to?(method_name)) || super
      end

      def each_display_group
        return unless block_given?

        ObservationDescription
          .in_display_order
          .to_a
          .group_by(&:display_group)
          .each do |group_number, array_of_obs_desc|
          group = array_of_obs_desc.map do |obs_desc|
            observation_hash = send(obs_desc.code.to_sym) || {}
            observed_at = observation_hash["observed_at"]
            Observation.new(
              code: obs_desc.code,
              result: observation_hash["result"],
              observed_at: observed_at && ::Time.zone.parse(observed_at),
              description: obs_desc
            )
          end

          yield group, group_number
        end
      end

      private

      def build_observation(code:, observation_hash:, with_description: false)
        Observation.new(
          code: code,
          result: observation_hash["result"],
          observed_at: ::Time.zone.parse(observation_hash["observed_at"]),
          description: with_description ? description_for(code) : nil
        )
      end

      def description_for(code)
        observation_description_map.fetch(code, "#{code} (no description found!)")
      end

      def observation_description_map
        @observation_description_map ||= begin
          ::Renalware::Pathology::ObservationDescription
            .pluck(:code, :name)
            .each_with_object({}) { |desc, hash| hash[desc.first] = desc.last }
        end
      end
    end
  end
end
