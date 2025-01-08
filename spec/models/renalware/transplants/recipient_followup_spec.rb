module Renalware
  module Transplants
    describe RecipientFollowup do
      it :aggregate_failures do
        is_expected.to belong_to(:operation).touch(true)
        is_expected.to have_many(:rejection_episodes)
        is_expected.to validate_timeliness_of(:stent_removed_on)
        is_expected.to validate_timeliness_of(:transplant_failed_on)
        is_expected.to validate_timeliness_of(:graft_nephrectomy_on)
        is_expected.to be_versioned
      end

      describe "#valid?" do
        subject do
          described_class.new(
            attributes_for(:transplant_recipient_followup).merge(attributes)
          )
        end

        let(:attributes) { {} }

        it { is_expected.to be_valid }

        context "when transplant failed" do
          let(:attributes) { { transplant_failed: true } }

          it :aggregate_failures do
            is_expected.to validate_presence_of(:transplant_failed_on)
            is_expected.to validate_presence_of(:transplant_failure_cause_description_id)
          end
        end

        context "with a transplant failure cause" do
          let(:description) do
            Renalware::Transplants::FailureCauseDescription.create(
              code: "41",
              name: "Other"
            )
          end
          let(:attributes) { { transplant_failure_cause_description_id: description.id } }

          it { is_expected.to validate_presence_of(:transplant_failure_cause_other) }
        end
      end
    end
  end
end
