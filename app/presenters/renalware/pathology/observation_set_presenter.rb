module Renalware
  module Pathology
    class ObservationSetPresenter
      attr_reader :observation_set, :code_group_name

      delegate :values, to: :observation_set, allow_nil: true

      def initialize(observation_set, code_group_name: "default")
        @observation_set = observation_set
        @code_group_name = code_group_name
      end

      class Observation
        attr_reader_initialize [:code, :description, :result, :observed_at]
      end

      def method_missing(method_name, **_args, &)
        values&.public_send(method_name)
      end

      def respond_to_missing?(method_name, _include_private = false)
        (values.present? && values.respond_to?(method_name)) || super
      end

      # rubocop:disable Layout/EmptyLinesAroundBlockBody
      def each_display_group
        return unless block_given?

        CodeGroup.find_by(name: code_group_name)
          .memberships
          .includes(:observation_description)
          .order(:subgroup, :position_within_subgroup)
          .group_by(&:subgroup).each do |(group_number, group_memberships)|

          observation_presenters = group_memberships.map do |code_group_membership|
            build_observation_presenter(code_group_membership)
          end

          yield observation_presenters, group_number
        end
      end
      # rubocop:enable Layout/EmptyLinesAroundBlockBody

      def build_observation_presenter(code_group_membership)
        observation_hash = send(code_group_membership.observation_description.code.to_sym) || {}
        observed_at = observation_hash["observed_at"]
        Observation.new(
          code: code_group_membership.observation_description.code,
          result: observation_hash["result"],
          observed_at: observed_at && ::Time.zone.parse(observed_at),
          description: code_group_membership.observation_description
        )
      end
    end
  end
end
