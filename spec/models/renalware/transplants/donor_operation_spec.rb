# frozen_string_literal: true

module Renalware
  module Transplants
    describe DonorOperation do
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to be_versioned
      end
    end
  end
end
