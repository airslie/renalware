module Renalware
  module Pathology
    # Applies submitted (unsaved) form attributes plus an optional editing command, such as adding
    # a result or a subgroup, to a CodeGroup in memory. Nothing is persisted. This lets the code
    # group editor re-render the form and preview from the posted state.
    class CodeGroupDraft
      NEW_MEMBERSHIP_POSITION = 10_000

      attr_reader :group, :attributes, :command

      def initialize(group, attributes:, command: {})
        @group = group
        @attributes = attributes.to_h.with_indifferent_access
        @command = command.to_h.with_indifferent_access
      end

      def apply
        remove_result
        group.assign_attributes(attributes)
        group.pad_subgroups
        add_subgroup
        remove_subgroup
        add_result
        group
      end

      private

      def remove_result
        key = command[:remove_result]
        return if key.blank?

        rows = attributes.dig(:memberships_attributes, key)
        rows[:_destroy] = "1" if rows
      end

      def add_subgroup
        return unless command[:name] == "add_subgroup"

        group.subgroup_titles += [""]
        group.subgroup_colours += [nil]
      end

      def remove_subgroup
        return unless command[:name] == "remove_subgroup"

        last = group.subgroup_count
        return if last <= 1 || group.active_memberships.any? { |membership|
          membership.subgroup == last
        }

        group.subgroup_titles = group.subgroup_titles.first(last - 1)
        group.subgroup_colours = group.subgroup_colours.first(last - 1)
      end

      def add_result
        return unless command[:name] == "add_result"

        description_id = command[:observation_description_id].to_i
        return if description_id.zero?
        return if group.active_memberships.any? { |m|
          m.observation_description_id == description_id
        }

        group.memberships.build(
          observation_description_id: description_id,
          subgroup: command[:subgroup].presence&.to_i || 1,
          position_within_subgroup: NEW_MEMBERSHIP_POSITION
        )
      end
    end
  end
end
