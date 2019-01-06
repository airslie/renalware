# frozen_string_literal: true

require "rails_helper"

module Renalware::Accesses
  describe Type, type: :model do
    it { is_expected.to validate_presence_of(:name) }
  end
end
