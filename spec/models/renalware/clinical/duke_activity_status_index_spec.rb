# frozen_string_literal: true

describe Renalware::Clinical::DukeActivityStatusIndex do # an event
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:score) }

    it do
      is_expected.to validate_numericality_of(:score)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(60)
    end
  end

  it "can be saved" do
    plan = described_class.new(
      patient: create(:patient),
      date_time: Time.current,
      description: "desc",
      event_type: create(:duke_activity_status_index_event_type),
      document: { score: 1 },
      by: create(:user)
    )

    expect(plan.save).to be(true)
  end
end
