require "./spec/support/login_macros"

module Renalware
  module PD
    describe Regime do
      it_behaves_like "an Accountable model"

      describe "validations" do
        it :aggregate_failures do
          is_expected.to validate_presence_of :patient
          is_expected.to validate_presence_of :start_date
          is_expected.to validate_timeliness_of(:start_date)
          is_expected.to validate_timeliness_of(:end_date)
          is_expected.to validate_presence_of :treatment
          is_expected.to belong_to(:system)
          is_expected.to belong_to(:patient).touch(true)
          is_expected.to have_one(:termination)
          is_expected.to respond_to(:assistance_type)
        end

        it "end_date must be after start_date" do
          regime = described_class.new(start_date: "2015-12-01", end_date: "2014-01-01")

          expect(regime.valid?).to be(false)
          expect(regime.errors[:end_date].first).to match(/must be on or after/)
        end
      end
    end
  end
end
