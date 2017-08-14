require "rails_helper"

module Renalware
  describe Modalities::Modality, type: :model do
    it { is_expected.to validate_presence_of :patient }
    it { is_expected.to validate_presence_of :started_on }
    it { is_expected.to validate_presence_of :description }

    it { is_expected.to belong_to(:patient).touch(true) }

    it { is_expected.to validate_timeliness_of(:started_on) }

    describe "validate start date based on previous modalities" do
      let!(:another_patients_modality) { create(:modality, started_on: Date.parse("2015-06-02")) }

      context "given there is no previous modality" do
        subject do
          build(:modality, started_on: Date.parse("2015-05-01"))
        end

        it "has a valid start date" do
          subject.valid?
          expect(subject.errors[:started_on]).to be_empty
        end
      end

      context "given there is a previous modality" do
        let!(:patients_modality) { create(:modality, started_on: Date.parse("2015-04-01")) }

        context "given start date is later than previous start date" do
          subject do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-05-01")
            )
          end

          it "has a valid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to be_empty
          end
        end

        context "given start date is the same as the previous start date" do
          subject do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-04-01")
            )
          end

          it "has a valid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to be_empty
          end
        end

        context "given start date is not later than previous start date" do
          subject do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-03-21")
            )
          end

          it "has an invalid start date" do
            subject.valid?
            expect(subject.errors[:started_on]).to include(/previous modality/)
          end
        end
      end
    end
  end
end
