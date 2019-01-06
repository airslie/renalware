# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe File do
    subject { Renalware::Feeds::File.new }

    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to respond_to(:by=) }
    it { is_expected.to belong_to(:file_type) }
  end
end
