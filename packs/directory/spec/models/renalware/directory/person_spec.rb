# frozen_string_literal: true

module Renalware
  module Directory
    describe Person do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:given_name)
        is_expected.to validate_presence_of(:family_name)
      end
    end
  end
end
