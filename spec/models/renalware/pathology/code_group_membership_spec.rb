# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::CodeGroupMembership, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:subgroup)
      is_expected.to validate_presence_of(:position_within_subgroup)
      is_expected.to belong_to(:code_group)
      is_expected.to belong_to(:observation_description)
    end
  end
end
