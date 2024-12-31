module Renalware
  module Pathology
    class OBXMapping < ApplicationRecord
      include RansackAll
      include Accountable

      belongs_to :sender
      belongs_to :observation_description

      validates :code_alias, presence: true, uniqueness: { scope: :sender_id }
      validates :sender, presence: true
      validates :observation_description, presence: true

      has_paper_trail(
        versions: { class_name: "Renalware::Pathology::Version" },
        on: [:create, :update, :destroy]
      )

      # Here we need to resolve exactly one ObservationDescription for a given
      # code eg 'HB' and sender (SendingFacility/SendingApplication from the HL7 MSH).
      # The sender has already been found/created and passed to us so we don't
      # need to worry about that.
      # What we need to do is to workout if the incoming code eg 'HB' exists in the obx_mapping
      # table for the current sender - this mechanism will let us accept eg 'HB' and map to the HGB
      # observation_description. Mostly there won't be an obx_mapping entry, but if there is
      # one, we return the mapped observation_description, otherwise return a direct match
      # against ObservationDescription code.
      #
      # Here is an example:
      #
      # incoming_code alias  SendingFacility SendingApplication  maps_to
      # HBN           HBN    Facility1       *                   => HGB
      # HB            HB     Facility1       *                   => HGB
      # HGB                                                      => HGB
      #
      def self.observation_description_for(code:, sender:)
        where = <<-SQL.squish
          (
            pathology_obx_mappings.code_alias = ? AND
            pathology_obx_mappings.sender_id = ?
          )
          OR
          (
            pathology_observation_descriptions.code = ?
          )
        SQL

        # The order here is significant. We want the most relevant result to float to the top,
        # that being the obx_mapping's observation_description_id if there is one, hence
        # being explicit about NULLS LAST just in case the default ordering is NULLS first.
        # So if there are two rows returned
        # 1 the obx_mapping onto 'CODE'
        # 2 the observation_description with code 'CODE' (which should not exist as it is unused but
        #   might as after all we create missing OBX codes automatically..) then
        # Then 1 should always float to the top and be returned.
        ObservationDescription
          .left_outer_joins(:obx_mappings)
          .where(where, code, sender.id, code)
          .order("pathology_obx_mappings.observation_description_id ASC NULLS LAST")
          .limit(1)
          .first
      end
    end
  end
end
