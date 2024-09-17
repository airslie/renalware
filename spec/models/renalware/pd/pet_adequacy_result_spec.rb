# frozen_string_literal: true

module Renalware
  module PD
    describe PETAdequacyResult do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_numericality_of(:dietry_protein_intake)
      end

      describe "validation" do
        PETAdequacyResult::MAXIMUMS.each do |attr_name, max_value|
          it {
            is_expected.to validate_numericality_of(attr_name).is_less_than_or_equal_to(max_value)
          }
        end
      end

      describe "pet_type" do
        it "is an enumerized enum" do
          expect(described_class.pet_type.values).to be_a(Array)
        end
      end
    end
  end
end
