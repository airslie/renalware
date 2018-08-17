# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    RSpec.describe TransmissionLog, type: :model do
      it { is_expected.to validate_presence_of(:direction) }
      it { is_expected.to validate_presence_of(:format) }
      it { is_expected.to belong_to(:hd_provider_unit) }
    end
  end
end