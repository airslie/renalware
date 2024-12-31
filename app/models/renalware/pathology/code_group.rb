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

      validates :name, presence: true, uniqueness: true
      validates :description, presence: true
      has_many(
        :memberships,
        -> { ordered },
        class_name: "CodeGroupMembership",
        dependent: :destroy
      )
      has_many :observation_descriptions, through: :memberships

      def self.descriptions_for_group(name)
        group = CodeGroup.find_by(name: name)
        return [] if group.nil?

        group
          .observation_descriptions
          .order(subgroup: :asc, position_within_subgroup: :asc)
      end
    end
  end
end
