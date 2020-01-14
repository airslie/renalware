# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe ContactDescription, type: :model do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:system_code)
        is_expected.to validate_presence_of(:name)
        is_expected.to validate_presence_of(:position)
      end
    end
  end
end
