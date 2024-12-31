module Renalware
  module Pathology
    # An ObservationDescription can be a member of many groups (a set of descriptions used for
    # displaying or printing a subset of context-specific results). Within each group,
    # say, 'letters', a description might be in a sub group (which merely serves to pull results
    # together in groups on the page for clarity) and within that group might have a position which
    # determines its order in the subgroup.
    class CodeGroupMembership < ApplicationRecord
      include Accountable
      has_paper_trail(
        versions: { class_name: "Renalware::Pathology::Version" },
        on: [:create, :update, :destroy]
      )
      validates :position_within_subgroup, presence: true
      validates :subgroup, presence: true
      belongs_to :code_group
      belongs_to :observation_description
      scope :ordered, -> { order(:subgroup, :position_within_subgroup) }
    end
  end
end
