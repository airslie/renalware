module Renalware
  describe RolesUser do
    it :aggregate_failures do
      is_expected.to belong_to :user
      is_expected.to belong_to :role
      is_expected.to respond_to(:id)
    end
  end
end
