module Renalware
  module Pathology
    # Represents a set of observation descriptions that are displayed together for example on a
    # letter on or an HD MDM.
    # We don't always want to display the same set of results. For example in the context of
    # an HD MDM we might want to display only HD-relevant results, while in the main historical
    # pathology view we want to see a wide set of results.
    # By defining a group with a name like 'letters' or 'pd_mdm' we can load and display
    # only the results in that group.
    # Check what codes are in which group manually in the rails console using e.g.
    #   Renalware::Pathology::CodeGroup.descriptions_for_group("letters")
    # (you can merge this as a scope also)
    # or in SQL using
    #   SELECT
    #     G.name,
    #     M.subgroup,
    #     M.position_within_subgroup,
    #     POD.code
    # FROM
    #     pathology_code_groups G
    #     INNER JOIN pathology_code_group_memberships M ON M.code_group_id = G.id
    #     INNER JOIN pathology_observation_descriptions POD ON POD.id = M.observation_description_id
    #     ORDER BY
    #         G.name,
    #         M.subgroup,
    #         M.position_within_subgroup;
    class CodeGroup < ApplicationRecord
      include Accountable

      has_paper_trail(
        versions: { class_name: "Renalware::Pathology::Version" },
        on: [:create, :update, :destroy]
      )

      COLOURS = %w(
        slate gray zinc neutral stone red orange amber yellow lime green emerald teal cyan sky
        blue indigo violet purple fuchsia pink rose
      ).freeze

      validates :name, presence: true, uniqueness: true
      validates :description, presence: true
      validates :title, presence: true, on: :design
      validate :subgroup_colours_are_known
      has_many(
        :memberships,
        -> { ordered },
        class_name: "CodeGroupMembership",
        dependent: :destroy
      )
      has_many :observation_descriptions, through: :memberships

      accepts_nested_attributes_for :memberships, allow_destroy: true

      before_validation :normalise_subgroups_and_positions

      def self.descriptions_for_group(name)
        group = CodeGroup.find_by(name: name)
        return [] if group.nil?

        group
          .observation_descriptions
          .order(subgroup: :asc, position_within_subgroup: :asc)
      end

      def subgroup_count(members = active_memberships)
        [
          Array(subgroup_titles).size,
          Array(subgroup_colours).size,
          members.filter_map(&:subgroup).max.to_i,
          1
        ].max
      end

      def active_memberships
        memberships.reject(&:marked_for_destruction?)
      end

      def deletable? = !context_specific? && name != "default"

      def subgroup_title(number) = Array(subgroup_titles)[number - 1]

      def subgroup_colour(number) = Array(subgroup_colours)[number - 1]

      def pad_subgroups(members = active_memberships)
        count = subgroup_count(members)
        self.subgroup_titles = padded(subgroup_titles, "", count)
        self.subgroup_colours = padded(subgroup_colours, nil, count)
      end

      private

      def subgroup_colours_are_known
        unknown = Array(subgroup_colours).compact_blank - COLOURS
        if unknown.any?
          errors.add(:subgroup_colours,
                     "include unknown colours: #{unknown.join(', ')}")
        end
      end

      # Must not load the memberships association: doing so when a group is first saved would
      # cache an empty list and hide memberships created afterwards.
      def normalise_subgroups_and_positions
        members = in_memory_memberships
        pad_subgroups(members)
        self.subgroup_colours = subgroup_colours.map(&:presence)
        renumber_positions(members)
      end

      def in_memory_memberships
        (memberships.loaded? ? memberships.to_a : memberships.target)
          .reject(&:marked_for_destruction?)
      end

      def padded(values, filler, count)
        Array(values).fill(filler, Array(values).size...count)
      end

      def renumber_positions(members)
        members.group_by(&:subgroup).each_value do |siblings|
          by_position = siblings.each_with_index
            .sort_by { |m, i| [m.position_within_subgroup.to_i, i] }
          by_position.each_with_index { |(m, _), i| m.position_within_subgroup = i + 1 }
        end
      end
    end
  end
end
