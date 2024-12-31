module Renalware
  module HD
    describe ProfileDocument::Dialysis, type: :model do
      subject(:dialysis) { described_class.new }

      describe "validation" do
        it :aggregate_failures do
          is_expected.to validate_numericality_of(:blood_flow).is_greater_than_or_equal_to(50)
          is_expected.to validate_numericality_of(:blood_flow).is_less_than_or_equal_to(800)
        end

        context "when it has sodium profiling" do
          before { dialysis.has_sodium_profiling = :yes }

          it :aggregate_failures do
            is_expected.to validate_presence_of(:sodium_first_half)
            is_expected.to validate_presence_of(:sodium_second_half)
          end
        end

        context "when it doesn't have sodium profiling" do
          before { dialysis.has_sodium_profiling = :no }

          it :aggregate_failures do
            is_expected.not_to validate_presence_of(:sodium_first_half)
            is_expected.not_to validate_presence_of(:sodium_second_half)
          end
        end

        context "when HD is HDF-PRE" do
          before { dialysis.hd_type = "hdf_pre" }

          it :substitution_percent do
            is_expected.to allow_value("", nil).for(:substitution_percent)
            is_expected.to validate_numericality_of(:substitution_percent)
              .is_greater_than_or_equal_to(45)
              .is_less_than_or_equal_to(60)
          end
        end

        context "when HD is HDF-POST" do
          before { dialysis.hd_type = "hdf_post" }

          it :substitution_percent do
            is_expected.to allow_value("", nil).for(:substitution_percent)
            is_expected.to validate_numericality_of(:substitution_percent)
              .is_greater_than_or_equal_to(20)
              .is_less_than_or_equal_to(30)
          end
        end
      end
    end
  end
end
