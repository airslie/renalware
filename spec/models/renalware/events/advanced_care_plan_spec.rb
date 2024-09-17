# frozen_string_literal: true

describe Renalware::Events::AdvancedCarePlan do
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:state) }
  end

  it "can be saved" do
    plan = described_class.new(
      patient: create(:patient),
      date_time: Time.current,
      description: "desc",
      event_type: create(:advanced_care_plan_event_type),
      document: { state: :not_required },
      by: create(:user)
    )

    expect(plan.save).to be(true)
  end
end
