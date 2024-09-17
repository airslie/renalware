# frozen_string_literal: true

describe Renalware::Pathology::Requests::GlobalRule::LatestCRFOlderThanWeeks do
  describe "#to_s" do
    subject { described_class.new(param_comparison_value: 12).to_s }

    it { is_expected.to eq("latest CRF older than 12 weeks") }
  end

  describe "#observation_required_for_patient" do
    subject { rule.observation_required_for_patient?(patient, Date.current) }

    let(:patient) { build_stubbed(:transplant_patient) }

    context "when the patient has no transplant registration" do
      it "does not require the observation" do
        rule = create_rule(weeks_ago: 12)
        patient = create(:transplant_patient)

        required = rule.observation_required_for_patient?(patient, Date.current)

        expect(required).to be(false)
      end
    end

    context "when the patient a Tx registration with a blank crf date" do
      it "does not require the observation" do
        registration = create_tx_registration(latest_crf_date_weeks_ago: nil)
        rule = create_rule(weeks_ago: 12)

        required = rule.observation_required_for_patient?(registration.patient, Date.current)

        expect(registration.document.crf.latest.recorded_on).to be_nil
        expect(required).to be(false)
      end
    end

    context "when the patient has a Tx registration with latest crf date 1 week ago" do
      it "does not require the observation" do
        registration = create_tx_registration(latest_crf_date_weeks_ago: 1)
        rule = create_rule(weeks_ago: 12)

        required = rule.observation_required_for_patient?(registration.patient, Date.current)

        expect(required).to be(false)
      end
    end

    context "when the patient has a Tx registration with latest crf date of yesterday" do
      it "requires the observation" do
        registration = create_tx_registration(latest_crf_date_weeks_ago: 13)
        rule = create_rule(weeks_ago: 12)

        required = rule.observation_required_for_patient?(registration.patient, Date.current)

        expect(required).to be(true)
      end
    end
  end

  def create_tx_registration(latest_crf_date_weeks_ago: nil)
    create(
      :transplant_registration,
      patient: create(:transplant_patient)
    ).tap do |registration|
      if latest_crf_date_weeks_ago
        crf_date = Date.current - latest_crf_date_weeks_ago.weeks
        registration.document.crf.latest.recorded_on = crf_date
        registration.save!
      end
    end
  end

  def create_rule(weeks_ago: 12)
    described_class.new(param_comparison_value: weeks_ago)
  end
end
