# frozen_string_literal: true

module Renalware
  module Patients
    describe Worry do
      let(:user) { create(:user) }
      let(:patient) { create(:patient, by: user) }

      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"

      it :aggregate_failures do
        is_expected.to respond_to(:notes)
        is_expected.to belong_to(:patient).touch(true)
      end

      describe "validation" do
        it "validates uniqueness of patient" do
          described_class.create!(patient: patient, by: user)

          expect { described_class.create!(patient: patient, by: user) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe "versioning" do
        with_versioning do
          it "stores a version on creation or deletion" do
            expect(PaperTrail).to be_enabled
            worry = described_class.create!(patient: patient, by: user)

            expect(worry.versions.count).to eq(1)

            worry.destroy!

            expect(worry.versions.count).to eq(2)
          end
        end
      end

      describe "uniqueness" do
        it "can only have one undeleted row per patient" do
          described_class.create!(patient: patient, by: user)

          expect {
            described_class.create!(patient: patient, by: user)
          }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it "successfully adds when deleted rows exist for the same patient" do
          described_class.create!(patient: patient, by: user, deleted_at: Time.zone.now)
          described_class.create!(patient: patient, by: user, deleted_at: Time.zone.now)

          described_class.create!(patient: patient, by: user)
        end
      end
    end
  end
end
