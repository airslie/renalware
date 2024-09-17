# frozen_string_literal: true

describe Renalware::Events::AlertableEventsQuery do
  describe "#call" do
    it "returns the most recent event matching the trigger" do
      patient = create(:patient)
      user = create(:user)
      event_type = create(:vaccination_event_type)
      Renalware::Events::EventTypeAlertTrigger.create!(
        event_type: event_type,
        when_event_document_contains: "covid"
      )

      events = [
        [3.days.ago, "covid"],
        [2.days.ago, "covid"],
        [4.days.ago, "covid"],
        [1.day.ago, "the"]
      ].map do |arr|
        create(
          :vaccination,
          patient: patient,
          date_time: arr[0],
          document: { type: arr[1], drug: "xxx" },
          created_at: arr[0],
          by: user
        )
      end

      results = described_class.call(patient: patient)

      expect(results.map(&:id).sort).to eq([events[1].id])
    end
  end
end
