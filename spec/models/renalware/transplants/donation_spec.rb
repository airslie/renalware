# frozen_string_literal: true

module Renalware
  module Transplants
    describe Donation do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:state)
        is_expected.to validate_presence_of(:relationship_with_recipient)
        is_expected.to validate_timeliness_of(:volunteered_on)
        is_expected.to validate_timeliness_of(:first_seen_on)
        is_expected.to validate_timeliness_of(:workup_completed_on)
        is_expected.to validate_timeliness_of(:donated_on)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end

      describe "#valid?" do
        subject {
          described_class.new(
            attributes_for(:transplant_donation).merge(attributes)
          )
        }

        let(:attributes) { {} }

        it { is_expected.to be_valid }

        context "when relationship is other and relationship is not supplied" do
          let(:attributes) do
            {
              state: :other_living_non_related,
              relationship_with_recipient_other: nil
            }
          end

          it { is_expected.not_to be_valid }
        end

        context "when assigning itself as a recipient" do
          let(:attributes) do
            {
              patient_id: 1,
              recipient_id: 1
            }
          end

          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
