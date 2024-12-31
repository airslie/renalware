module Renalware
  module Surveys
    describe Survey do
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to have_many(:questions)
        is_expected.to validate_presence_of :name
        is_expected.to have_db_index(:name)
        is_expected.to have_db_index(:deleted_at)
      end

      describe "#uniqueness" do
        subject { described_class.new(name: "x", code: "x") }

        it { is_expected.to validate_uniqueness_of :name }
      end
    end
  end
end
