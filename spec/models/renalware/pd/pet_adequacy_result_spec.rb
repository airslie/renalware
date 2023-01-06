# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe PETAdequacyResult do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_numericality_of(:dietry_protein_intake)
      end

      describe "validation" do
        before do
          # Thus is a small performance optimisation to speed up shoulda's validation tests.
          # The tests are spending a lot of time looking up error messages.
          allow_any_instance_of(ActiveModel::Errors)
            .to receive(:generate_message)
            .and_return("error message")
        end

        PETAdequacyResult::MAXIMUMS.each do |attr_name, max_value|
          it {
            is_expected.to validate_numericality_of(attr_name).is_less_than_or_equal_to(max_value)
          }
        end
      end

      describe "pet_type" do
        it "is an enumerized enum" do
          expect(described_class.pet_type.values).to be_kind_of(Array)
        end
      end
    end
  end
end
