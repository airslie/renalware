# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Transplants
    describe DonorOperation do
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:performed_on)
      end
    end
  end
end
