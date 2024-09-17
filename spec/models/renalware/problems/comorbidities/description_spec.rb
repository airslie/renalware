# frozen_string_literal: true

module Renalware::Problems
  describe Comorbidities::Description do
    it_behaves_like "a Paranoid model"

    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:position)
      is_expected.to have_db_index(:position)
      is_expected.to have_db_index(:deleted_at)
    end

    describe "uniqueness" do
      describe "#name" do
        subject { described_class.new(position: 1, name: "x") }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
