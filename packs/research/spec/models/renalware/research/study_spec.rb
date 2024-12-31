module Renalware
  describe Research::Study do
    it :aggregate_failures do
      is_expected.to be_versioned
      is_expected.to validate_presence_of :code
      is_expected.to validate_presence_of :description
      is_expected.to have_db_index(:code)
      is_expected.to have_db_index(:description)
      is_expected.to have_many(:participations)
      is_expected.to have_many(:patients).through(:participations)
      is_expected.to have_many(:investigatorships)
      is_expected.to respond_to(:namespace)
    end

    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
  end
end
