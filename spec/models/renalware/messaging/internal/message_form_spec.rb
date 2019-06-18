# frozen_string_literal: true

require "rails_helper"

module Renalware::Messaging::Internal
  describe MessageForm, type: :model do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
