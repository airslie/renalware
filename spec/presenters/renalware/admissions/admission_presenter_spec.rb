# frozen_string_literal: true

module Renalware
  module Admissions
    describe AdmissionPresenter do
      describe "#length_of_stay" do
        context "when the patient has not yet been discharged" do
          it "returns the number of days since admission" do
            admission = instance_double(
              Admission,
              admitted_on: 1.week.ago,
              discharged_on: nil
            )

            los = described_class.new(admission).length_of_stay

            expect(los).to eq(7)
          end
        end

        context "when the patient has been discharged" do
          it "returns the day between admission and discharge" do
            admission = instance_double(
              Admission,
              admitted_on: 1.week.ago,
              discharged_on: 1.day.ago
            )

            los = described_class.new(admission).length_of_stay

            expect(los).to eq(6)
          end
        end
      end
    end
  end
end
