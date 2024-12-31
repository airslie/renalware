module Renalware
  module HD
    describe Session::Open do
      subject(:session) do
        build(:hd_open_session, patient: patient, signed_on_by: nurse, by: nurse)
      end

      let(:nurse) { create(:user) }
      let(:patient) { create(:hd_patient) }

      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:signed_on_by)
        is_expected.to validate_presence_of(:started_at)
        is_expected.to validate_presence_of(:hospital_unit)
        is_expected.not_to validate_presence_of(:signed_off_by)
        is_expected.not_to validate_presence_of(:stopped_at)
        is_expected.to validate_timeliness_of(:started_at)
        is_expected.to validate_timeliness_of(:stopped_at)
      end

      it "is not immutable" do
        expect(described_class.new.immutable?).to be(false)
      end

      it "defines a policy class" do
        expect(described_class.policy_class).to eq(OpenSessionPolicy)
      end

      it "is valid" do
        expect(session).to be_valid
      end

      describe "immutable?" do
        it "always returns false" do
          expect(session.immutable?).to be(false)
        end
      end

      context "with a patient in a modality" do
        let!(:modality) { create(:modality, patient: patient) }

        context "when creating the record" do
          it "associates the patient current modality" do
            session.save!
            expect(session.modality_description_id).to eq(modality.description.id)
          end
        end
      end

      context "with duration" do
        context "when changing stopped_at" do
          it "computes the duration in minutes" do
            session.stopped_at = session.started_at + 30.minutes
            session.save!
            expect(session.duration).to eq(30)
          end
        end

        context "when changing started_at" do
          it "computes the duration in minutes" do
            session.stopped_at = session.started_at + 1.hour
            session.save!

            session.started_at = session.stopped_at - 30.minutes
            session.save!

            expect(session.duration).to eq(30)
          end
        end
      end
    end
  end
end
