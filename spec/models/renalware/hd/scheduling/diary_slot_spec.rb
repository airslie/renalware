# frozen_string_literal: true

module Renalware::HD::Scheduling
  describe DiarySlot do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to belong_to(:diary).touch(true)
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to belong_to(:station)
      is_expected.to belong_to(:diurnal_period_code)
      is_expected.to validate_presence_of(:diary)
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:station)
      is_expected.to validate_presence_of(:day_of_week)
      is_expected.to validate_presence_of(:diurnal_period_code)
      is_expected.to validate_inclusion_of(:day_of_week).in_range(1..7)
    end

    describe "#to_s" do
      context "when there is no arrival_time" do
        it "returns just the patient name" do
          patient = build(:hd_patient, family_name: "Cobb", given_name: "Jo")
          slot = described_class.new(patient: patient)

          expect(slot.to_s).to eq("COBB, Jo")
        end
      end

      context "when there is an arrival_time" do
        it "returns just the patient name and arrival time" do
          patient = build(:hd_patient, family_name: "Cobb", given_name: "Jo")
          slot = described_class.new(patient: patient, arrival_time: Time.zone.parse("11:21"))

          expect(slot.to_s).to eq("COBB, Jo (11:21)")
        end
      end

      context "when there is no patient" do
        it "returns an empty string" do
          slot = described_class.new(patient: nil, arrival_time: Time.zone.parse("11:21"))

          expect(slot.to_s).to eq("")
        end
      end
    end
  end
end
