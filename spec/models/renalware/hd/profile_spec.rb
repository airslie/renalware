# frozen_string_literal: true

module Renalware
  module HD
    describe Profile do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Supersedable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:prescriber)
        is_expected.to respond_to(:active)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:dialysate)
        is_expected.to belong_to(:schedule_definition)
        is_expected.to be_versioned
      end

      describe "#home_machine_identifier" do
        let(:user) { create(:user) }
        let(:patient) { create(:hd_patient, by: user) }

        it "does not allow a duplicate value among any active profile" do
          active_profile = described_class.create!(
            patient: patient,
            prescriber: user,
            by: user,
            deactivated_at: nil,
            active: nil,
            home_machine_identifier: "ABC"
          )

          expect {
            active_profile.dup.save!
          }.to raise_error(
            ActiveRecord::RecordInvalid,
            "Validation failed: Home Machine Identifier has already been taken"
          )
        end

        it "allows duplicate values among soft-deleted HD Profiles" do
          active_profile = described_class.create!(
            patient: patient,
            prescriber: user,
            by: user,
            deactivated_at: nil,
            active: nil,
            home_machine_identifier: "ABC"
          )

          expect {
            active_profile.dup.update!(deactivated_at: 2.days.ago, active: nil)
            active_profile.dup.update!(deactivated_at: 1.day.ago, active: nil)
          }.not_to raise_error
        end

        it "allows duplicate blank values" do
          active_profile = described_class.create!(
            patient: patient,
            prescriber: user,
            by: user,
            deactivated_at: nil,
            active: nil,
            home_machine_identifier: ""
          )

          expect {
            active_profile.dup.update!(home_machine_identifier: "")
          }.not_to raise_error
        end

        it "disallows case-variable duplicates" do
          active_profile = described_class.create!(
            patient: patient,
            prescriber: user,
            by: user,
            deactivated_at: nil,
            active: nil,
            home_machine_identifier: "ABC"
          )

          expect {
            active_profile.dup.update!(home_machine_identifier: "abc")
          }.to raise_error(
            ActiveRecord::RecordInvalid,
            "Validation failed: Home Machine Identifier has already been taken"
          )
        end
      end
    end
  end
end
