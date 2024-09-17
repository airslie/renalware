# frozen_string_literal: true

describe Renalware::HD::Sessions::PreviousSessionDatesComponent, type: :component do
  let(:patient) { create(:hd_patient) }
  let(:instance) { described_class.new(patient: patient) }

  describe "#previous_sessions" do
    let(:second_patient) { create(:hd_patient) }

    context "when sessions exist" do
      it "returns last sessions in started at order" do
        _another_session = create(:hd_session, patient: second_patient, started_at: 1.day.ago)
        older_session = create(:hd_session, patient: patient, started_at: 2.weeks.ago)
        newer_session = create(:hd_session, patient: patient, started_at: 1.week.ago)

        expect(instance.previous_sessions).to eq(
          [
            newer_session,
            older_session
          ]
        )
      end
    end

    context "with no sessions" do
      it "returns empty" do
        expect(instance.previous_sessions).to eq []
      end
    end
  end

  describe "#render" do
    context "when a session exists" do
      let(:start_date) { 1.week.ago - 6.days }

      it "renders a list of previous sessions" do
        session = create(:hd_session, patient: patient, started_at: start_date)

        render_inline(instance)

        expect(page).to have_content(session.started_at.strftime("%d-%b"))
      end
    end

    context "with no sessions" do
      it "renders nothing" do
        render_inline(instance)
        expect(page.text).to eq ""
      end
    end
  end

  describe "#not_recommended_values" do
    let(:current_session) { build_stubbed(:hd_session, started_at: Date.parse("2022-09-09")) }
    let(:valid_session) { build_stubbed(:hd_session, started_at: Date.parse("2022-09-10")) }

    before do
      allow(instance).to receive(:previous_sessions).and_return([current_session, valid_session])
    end

    it "returns a list of dates that need to be warned for" do
      expect(instance.not_recommended_values(current_session)).to eq ["10-Sep-2022"]
    end

    context "when started at is nil for current session (ex: new session)" do
      let(:current_session) { build_stubbed(:hd_session, started_at: nil) }

      it "still works as expected" do
        expect(instance.not_recommended_values(current_session)).to eq ["10-Sep-2022"]
      end
    end
  end
end
