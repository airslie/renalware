describe Renalware::Events::ClinicalFrailtyScore do # an event
  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to validate_presence_of(:score) }
  end

  it "can be saved" do
    plan = described_class.new(
      patient: create(:patient),
      date_time: Time.current,
      description: "desc",
      event_type: create(:clinical_frailty_score_event_type),
      document: { score: 1 },
      by: create(:user)
    )

    expect(plan.save).to be(true)
  end
end
