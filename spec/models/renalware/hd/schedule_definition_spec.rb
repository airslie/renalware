module Renalware::HD
  describe ScheduleDefinition do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:days)
      is_expected.to validate_presence_of(:diurnal_period_id)
      is_expected.to belong_to(:diurnal_period)
    end

    describe "#to_s" do
      it "formats definition in eg Mon, Wed, Thur AM" do
        diurnal_period = DiurnalPeriodCode.new(code: "am")
        definition = described_class.new(days: [1, 3, 5], diurnal_period:)

        expect(definition.to_s).to eq("Mon Wed Fri AM")
      end
    end

    describe "generated days_text" do
      it "derives days_text from days when creating a record" do
        definition = create(:schedule_definition, days: [1, 3, 5])

        expect(definition.reload.days_text).to eq("Mon Wed Fri")
      end

      it "keeps days_text in sync when days is updated in SQL" do
        definition = create(:schedule_definition, days: [1, 3, 5])

        described_class.where(id: definition.id).update_all("days = '{2,4,6}'")

        expect(definition.reload.days_text).to eq("Tue Thu Sat")
      end
    end
  end
end
