# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe RolesUser, type: :model do
    it :aggregate_failures do
      is_expected.to belong_to :user
      is_expected.to belong_to :role
      is_expected.to respond_to(:id)
    end
  end
end
