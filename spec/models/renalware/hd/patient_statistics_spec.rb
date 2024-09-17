# frozen_string_literal: true

module Renalware
  module HD
    describe PatientStatistics do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:hospital_unit)
        is_expected.to validate_presence_of(:patient)
        is_expected.to have_db_index(:patient_id)
        is_expected.to have_db_index(%i(patient_id month year)).unique(true)
      end

      describe "month and year presence validation" do
        context "when rolling is nil" do
          subject { described_class.new(rolling: nil) }

          it :aggregate_failures do
            is_expected.to validate_presence_of(:year)
            is_expected.to validate_presence_of(:month)
          end
        end

        context "when rolling is true" do
          subject { described_class.new(rolling: true) }

          it :aggregate_failures do
            is_expected.not_to validate_presence_of(:year)
            is_expected.not_to validate_presence_of(:month)
          end
        end
      end
    end
  end
end
