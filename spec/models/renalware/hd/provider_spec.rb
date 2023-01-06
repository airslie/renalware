# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe Provider do
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
