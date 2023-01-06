# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Modalities::Modality do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of :patient
      is_expected.to validate_presence_of :started_on
      is_expected.to validate_presence_of :description
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to validate_timeliness_of(:started_on)
    end

    describe "validate start date based on previous modalities" do
      before do
        # another_patients_modality
        create(:modality, started_on: Date.parse("2015-06-02"))
      end

      context "when there is no previous modality" do
        subject(:modality) do
          build(:modality, started_on: Date.parse("2015-05-01"))
        end

        it "has a valid start date" do
          modality.valid?
          expect(modality.errors[:started_on]).to be_empty
        end
      end

      context "when there is a previous modality" do
        let!(:patients_modality) { create(:modality, started_on: Date.parse("2015-04-01")) }

        context "when the start date is later than previous start date" do
          subject(:modality) do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-05-01")
            )
          end

          it "has a valid start date" do
            modality.valid?
            expect(modality.errors[:started_on]).to be_empty
          end
        end

        context "when the start date is the same as the previous start date" do
          subject(:modality) do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-04-01")
            )
          end

          it "has a valid start date" do
            modality.valid?
            expect(modality.errors[:started_on]).to be_empty
          end
        end

        context "when start date is not later than previous start date" do
          subject(:modality) do
            build(
              :modality,
              patient: patients_modality.patient,
              started_on: Date.parse("2015-03-21")
            )
          end

          it "has an invalid start date" do
            modality.valid?
            expect(modality.errors[:started_on]).to include(/previous modality/)
          end
        end
      end

      it "does not allow a modality start date in the future" do
        modality = build(:modality, patient: nil, started_on: 1.day.from_now.to_date)

        expect(modality).not_to be_valid

        expect(modality.errors[:started_on]).to include("must be on or before #{Date.current}")
      end
    end
  end
end
