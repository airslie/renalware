# frozen_string_literal: true

module Renalware
  module HD
    describe SlotRequest do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to be_versioned
        is_expected.to belong_to(:patient)
        is_expected.to belong_to(:deletion_reason)
        is_expected.to belong_to(:location)
        is_expected.to belong_to(:access_state)
        is_expected.to validate_presence_of(:patient_id)
        is_expected.to validate_presence_of(:urgency)
        is_expected.to validate_presence_of(:notes)
        is_expected.to validate_presence_of(:location)
        is_expected.to validate_presence_of(:access_state)
      end

      describe "uniqueness" do
        subject do
          described_class.new(
            patient_id: patient.id,
            by: user,
            urgency: "urgent",
            deleted_at: nil,
            allocated_at: Time.zone.now
          )
        end

        let(:patient) { create(:patient) }
        let(:user) { create(:user) }

        it "is scoped so only 1 patient_id possible where deleted_at and allocated_at are null" do
          is_expected
            .to validate_uniqueness_of(:patient_id)
            .scoped_to([:deleted_at, :allocated_at])
            .with_message("already has an active slot request")
        end
      end
    end
  end
end
