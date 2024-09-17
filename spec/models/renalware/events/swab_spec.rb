# frozen_string_literal: true

module Renalware::Events
  describe Swab do
    describe "#document" do
      subject { described_class.new.document }

      it { is_expected.to validate_presence_of(:type) }
    end
  end
end
