# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinical::FrailtyScore, type: :model do # an event
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:score) }
  end

  it "can be saved" do
    plan = described_class.new(
      patient: create(:patient),
      date_time: Time.current,
      description: "desc",
      event_type: create(:clinical_frailty_score),
      document: { score: 1 },
      by: create(:user)
    )

    expect(plan.save).to eq(true)
  end
end
