# frozen_string_literal: true

module Renalware
  RSpec.describe Medications::ReviewDetail do
    subject { described_class.new(record) }

    let(:record) { build(:medication_review) }

    it "renders nothing" do
      expect(fragment.text).to eq("")
    end
  end
end
