module Renalware
  module HD
    describe Dialysate do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:name)
        is_expected.to validate_presence_of(:sodium_content)
        is_expected.to validate_numericality_of(:sodium_content)
        is_expected.to validate_presence_of(:sodium_content_uom)
        is_expected.to validate_numericality_of(:bicarbonate_content)
        is_expected.to validate_numericality_of(:calcium_content)
        is_expected.to validate_numericality_of(:glucose_content)
        is_expected.to validate_numericality_of(:potassium_content)
      end

      it_behaves_like "a Paranoid model"

      describe "uniqueness" do
        subject { described_class.new(name: "x", sodium_content: 1, sodium_content_uom: "mmol/L") }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
