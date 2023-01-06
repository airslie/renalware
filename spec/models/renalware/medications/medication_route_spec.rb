# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    describe MedicationRoute do
      subject(:route) { described_class.new }

      it :aggregate_failures do
        is_expected.to validate_presence_of :code
        is_expected.to validate_presence_of :name
        is_expected.to have_db_index(:code).unique(true)
      end

      describe "#other?" do
        it "case-insenstively matches the code 'other'" do
          expect(described_class.new(code: "other").other?).to be(true)
          expect(described_class.new(code: "OTHER").other?).to be(true)
        end
      end
    end
  end
end
